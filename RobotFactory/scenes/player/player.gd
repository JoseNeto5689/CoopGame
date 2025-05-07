extends CharacterBody2D

#region variables

@export var SPEED = 0

@onready var sprites = $AnimatedSprite2D
@onready var name_label = $PlayerName
@onready var camera = $PlayerCamera
@onready var item = $Item

var pendrive_stats : RobotStats
var has_item := false

var last_direction := Vector2.ZERO
var buttons_pressed := []

var spawn_position := Vector2.ZERO
var id : int
var player_name : String
var holding_interaction := false 
var animation_concluded := false

signal interacting
signal stop_interacting
signal given_item(robot_stats: RobotStats)

#endregion


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
	if (event.is_action_pressed("interact")):
		holding_interaction = true
		interacting.emit()
	elif (event.is_action_released("interact")):
		holding_interaction = false
		stop_interacting.emit()

func _ready() -> void:
	if (player_name):
		name_label.text = player_name
	global_position = spawn_position
	if is_multiplayer_authority():
		camera.make_current()

func _process(delta: float) -> void:
	if not is_multiplayer_authority():
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
func get_item():
	if not has_item and animation_concluded and Global.usb_stick_number > 0:
		Global.update_usb_stick_number(-1)
		has_item = true
		item.visible = true
		pendrive_stats = Global.copy_robot_stats(Global.robot_status)
	
@rpc("any_peer", "call_local")
func give_item():
	if has_item and animation_concluded:
		has_item = false
		item.visible = false
		given_item.emit(pendrive_stats)
		pendrive_stats = null
