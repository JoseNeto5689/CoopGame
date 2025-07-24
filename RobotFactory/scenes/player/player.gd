extends CharacterBody2D

#region variables

@export var SPEED = 0

@export var usb_stick_img : CompressedTexture2D
@export var gpu_img : CompressedTexture2D
@export var hd_img : CompressedTexture2D
@export var ram_img : CompressedTexture2D
@export var toolkit_img : CompressedTexture2D
@export var med_kit_img : CompressedTexture2D
@export var ssd_img : CompressedTexture2D
@export var cpu_img : CompressedTexture2D

@export var coffe_img : CompressedTexture2D
@export var wifi_img : CompressedTexture2D

@onready var sprites = $AnimatedSprite2D
@onready var name_label = $PlayerName
@onready var camera = $PlayerCamera
@onready var item = $Item

var pendrive_stats : RobotStats = RobotStats.new()
var has_item := false
var current_item := ""
var dead = false

var time_elapsed_while_dead: float = 0.0

var last_direction := Vector2.ZERO
var buttons_pressed := []
var can_move := true
var spawn_position := Vector2.ZERO
var id : int
var player_name : String
var holding_interaction := false 
var animation_concluded := false

signal interacting(player_id: int, item: String)
signal stop_interacting
signal given_usb_stick(id,robot_stats: RobotStats)
signal player_entered_heal_zone(dead_player_id: int, player_id: int)
signal player_exited_heal_zone(dead_player_id: int, player_id: int)
signal healing_player
signal usb_stick_given

#endregion

func format_time(seconds: float) -> String:
	var whole = int(seconds)
	var decimals = int((seconds - whole) * 100)
	return "%d.%02d" % [whole, decimals]
	

func get_direction() -> Vector2:
	if (Input.is_action_just_pressed("up")):
		buttons_pressed.append(Vector2(0,-1))
	if (Input.is_action_just_pressed("down")):
		buttons_pressed.append(Vector2(0,1))
	if (Input.is_action_just_pressed("left")):
		buttons_pressed.append(Vector2(-1,0))
	if (Input.is_action_just_pressed("right")):
		buttons_pressed.append(Vector2(1,0))
	
	if (Input.is_action_just_released("up")):
		buttons_pressed.erase(Vector2(0,-1))
	if (Input.is_action_just_released("down")):
		buttons_pressed.erase(Vector2(0,1))
	if (Input.is_action_just_released("left")):
		buttons_pressed.erase(Vector2(-1,0))
	if (Input.is_action_just_released("right")):
		buttons_pressed.erase(Vector2(1,0))
	
	if(buttons_pressed.is_empty()):
		return Vector2.ZERO
	return buttons_pressed[0]

func set_animation(direction: Vector2) -> void: 
	if(direction == Vector2.ZERO): 
		$AudioStreamPlayer2D.stop()
		if(last_direction == Vector2(0,1)):
			sprites.play("adam_idle_front")
		if(last_direction == Vector2(0,-1)):
			sprites.play("adam_idle_back")
		if(last_direction == Vector2(1,0)):
			sprites.play("adam_idle_right")
		if(last_direction == Vector2(-1,0)):
			sprites.play("adam_idle_left")
	else:
		last_direction = direction
		if not $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.play()
	if(direction == Vector2(0,1)):
		sprites.play("adam_running_front")
	if(direction == Vector2(0,-1)):
		sprites.play("adam_running_back")
	if(direction == Vector2(1,0)):
		sprites.play("adam_running_right")
	if(direction == Vector2(-1,0)):
		sprites.play("adam_running_left")

func _enter_tree() -> void:
	set_multiplayer_authority(id)

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("interact") and not dead):
		holding_interaction = true
		interacting.emit(id,current_item)
	elif (event.is_action_released("interact") and not dead):
		holding_interaction = false
		stop_interacting.emit()

func _ready() -> void:
	if (player_name):
		name_label.text = player_name
	global_position = spawn_position
	if is_multiplayer_authority():
		camera.make_current()

func _process(delta: float) -> void:
	if dead:
		time_elapsed_while_dead += delta
		
	if not is_multiplayer_authority() or dead or not can_move:
		return
	var direction = get_direction()
	set_animation(direction)
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_collide(velocity * delta)

func set_animation_status(status: bool):
	animation_concluded = status

@rpc("any_peer", "call_local")
func get_item(item_name : String):
	if not has_item and animation_concluded:
		has_item = true
		match item_name:
			"usb_stick":
				item.texture = usb_stick_img
				pendrive_stats = RobotStats.new()
			"gpu":
				item.texture = gpu_img
			"hd":
				item.texture = hd_img
			"ram":
				item.texture = ram_img
			"toolkit":
				item.texture = toolkit_img
			"medkit":
				item.texture = med_kit_img
			"ssd":
				item.texture = ssd_img
			"cpu":
				item.texture = cpu_img
				
		item.visible = true
		current_item = item_name
		$AnimatedSprite2D.play("get_item")
		can_move = false
		await get_tree().create_timer(0.5).timeout
		buttons_pressed = []
		last_direction = Vector2.ZERO
		$AnimatedSprite2D.play("adam_idle_front")
		can_move = true
		SaveData.save_log(Log.new(id, "Player comprou item %s" % item_name))
	
@rpc("any_peer", "call_local")
func show_item_purchased(item_purchased: String):
	if item_purchased == "coffe":
		$Item.texture = coffe_img
	if item_purchased == "wifi":
		$Item.texture = wifi_img
	$Item.show()
	$AnimatedSprite2D.play("get_item")
	can_move = false
	await get_tree().create_timer(0.5).timeout
	buttons_pressed = []
	last_direction = Vector2.ZERO
	$AnimatedSprite2D.play("adam_idle_front")
	$Item.hide()
	can_move = true

@rpc("any_peer", "call_local")
func give_item(player_id: int, _item: String):
	if has_item and animation_concluded:
		has_item = false
		item.visible = false
		given_usb_stick.emit(id,pendrive_stats)
		pendrive_stats = null

@rpc("any_peer", "call_local")
func interact_with_deployer(player_id: int, _item: String):
	if has_item and current_item == "usb_stick":
		Global.update_usb_stick_number(+1)
		has_item = false #Colocar tudo isso em uma func
		current_item = ""
		item.visible = false
		pendrive_stats = RobotStats.new()
	elif not has_item and Global.usb_stick_number > 0:
		$AnimatedSprite2D.play("adam_idle_back")
		buttons_pressed = []
		last_direction = Vector2.ZERO
		can_move = false
		usb_stick_given.emit(id)

@rpc("any_peer", "call_local")
func finish_deployer_transfer():
	if multiplayer.is_server():
		Global.update_usb_stick_number.rpc(-1)
	$AnimatedSprite2D.play("get_item")
	has_item = true
	item.texture = usb_stick_img
	item.visible = true
	pendrive_stats = Global.copy_robot_stats(Global.robot_status)
	await get_tree().create_timer(0.5).timeout
	$AnimatedSprite2D.play("adam_idle_front")
	can_move = true
	SaveData.save_log(Log.new(id, "Player pegou pendrive no deployer"))

@rpc("any_peer", "call_local")
func clear_item():
	current_item = ""
	has_item = false
	item.visible = false
	
@rpc("any_peer", "call_local")
func reset_item(player_id: int, _item: String):
	current_item = ""
	has_item = false
	item.visible = false
	
@rpc("any_peer", "call_local")
func discard_item(player_id: int, item_name: String):
	current_item = ""
	has_item = false
	item.visible = false
	SaveData.save_log(Log.new(player_id, "Player jogou o item %s no lixo" % item_name))
	
func update_camera_limits(list: Array):
	$PlayerCamera.limit_left = list[0]
	$PlayerCamera.limit_top = list[1]
	$PlayerCamera.limit_right = list[2]
	$PlayerCamera.limit_bottom = list[3]

func die():
	last_direction = Vector2.ZERO
	buttons_pressed = []
	position.y += 10
	position.x = int(position.x)
	position.y = int(position.y)
	dead = true
	$Item.hide()
	$DeadBody/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = true
	$HealZone/CollisionShape2D.disabled = false
	$AnimatedSprite2D.play("dead")
	SaveData.save_log(Log.new(id, "Player morreu"))

@rpc("any_peer", "call_local")
func revive():
	if multiplayer.is_server():
		print(multiplayer.get_unique_id())
		SaveData.save_log(Log.new(id, "Player revivido apos %f segundos" % time_elapsed_while_dead))
	time_elapsed_while_dead = 0
	position.y -= 5
	dead = false
	if (has_item):
		item.show()
	$DeadBody/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = false
	$HealZone/CollisionShape2D.disabled = true
	$AnimatedSprite2D.play("adam_idle_front")

@rpc("any_peer", "call_local")
func heal_player(player_id: int, _item: String):
	if current_item == "medkit":
		item.visible = false
		current_item = ""
		has_item = false
		healing_player.emit()
		SaveData.save_log(Log.new(id, "Player curou outro player"))
		

func turn_off_lights():
	$LightOccluder2D.hide()
	$PointLight2D.hide()

func turn_on_lights():
	$LightOccluder2D.show()
	$PointLight2D.show()

func _on_heal_zone_body_entered(body: Node2D) -> void:
	player_entered_heal_zone.emit(id,body.id)

func _on_heal_zone_body_exited(body: Node2D) -> void:
	player_exited_heal_zone.emit(id,body.id)
