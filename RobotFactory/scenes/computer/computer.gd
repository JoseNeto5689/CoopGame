extends Node2D

@export var pc_id := 0
@export var time_for_conclude := 0
@export var texture_on: CompressedTexture2D = null
@export var texture_off: CompressedTexture2D = null
@onready var progress_bar := $ProgressBar
@onready var timer := $Timer
@onready var pc_sprite := $ComputerSprite

signal work_concluded(pc_id: int)

signal player_entered_pc(id: int, pc_id: int)
signal player_exited_pc(id: int, pc_id: int)
signal pc_fixed
signal item_used
signal pc_exploded(list: Array)

var tween_turning_off : Tween

var is_animation_concluded := false
var working := false
var concluded := false
var players_interacting = []
var players_in_death_zone = []

@export var broken := false

@export var missing_ram := false
@export var missing_gpu := false
@export var missing_hd := false
@export var missing_cpu := false
@export var missing_ssd := false

func _ready() -> void:
	if missing_cpu:
		$Items/Center/CPU.show()
	if missing_gpu:
		$Items/Center/GPU.show()
	if missing_ssd:
		$Items/Center/SSD.show()
	if missing_hd:
		$Items/Center/HD.show()
	if missing_ram:
		$Items/Center/RAM.show()
	timer.wait_time = time_for_conclude
	pc_sprite.texture = texture_off

func _process(_delta: float) -> void:
	if(working and not concluded):
		if(timer.is_stopped()):
			timer.start()
		timer.paused = false
		var percentage := get_percentage()
		change_progress(percentage)

func change_progress(value: int): 
	progress_bar.value = value

func get_percentage() -> int:
	return abs(int(100-(timer.time_left/timer.wait_time)*100))

func show_progress_bar():
	progress_bar.visible = true

func hide_progress_bar():
	progress_bar.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "id" in body:
		player_entered_pc.emit(body.id, pc_id)
	players_interacting.append(body.id)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if "id" in body:
		player_exited_pc.emit(body.id, pc_id)
	players_interacting.erase(body.id)

func _on_timer_timeout() -> void:
	concluded = true
	var tween = create_tween()
	tween.tween_method(self.change_blink_intensity, 1.0, 0.0, 0.3)
	$ConcludedSound.play()
	await tween.finished
	reset()
	change_progress(0)
	stop_progress()
	work_concluded.emit(pc_id)

@rpc("any_peer", "call_local")
func increase_progress(_item: String):
	if is_animation_concluded and not broken:
		#$PointLight2D.enabled = true
		if(get_percentage() == 0):
			change_progress(0)
		working = true
		$TypingSound.play()
		if tween_turning_off:
			tween_turning_off.kill()
			
		pc_sprite.texture = texture_on
	
@rpc("any_peer", "call_local")
func stop_progress():
	working = false
	$TypingSound.stop()
	timer.paused = true
	tween_turning_off = create_tween()
	tween_turning_off.tween_property(pc_sprite, "texture", texture_off, 0.2)

@rpc("any_peer", "call_local")
func reset():
	working = false
	concluded = false
	
@rpc("any_peer", "call_local")
func reduce_speed(speed: int):
	var tween = create_tween()
	tween.tween_method(self.change_blink_intensity, 1.0, 0.0, 0.3)
	$PowerUpSound.play()
	timer.stop()
	change_progress(0)
	time_for_conclude -= speed
	timer.wait_time = time_for_conclude

func animation_changed(status: bool):
	is_animation_concluded = status

func change_blink_intensity(new_value: float):
	$ComputerSprite.material.set_shader_parameter("blink_intensity", new_value)

@rpc("any_peer", "call_local")
func fix_pc(_item: String):
	if(broken):
		item_used.emit()
		var tween = create_tween()
		tween.tween_method(self.change_blink_intensity, 1.0, 0.0, 0.3)
		$PowerUpSound.play()
		await tween.finished
		broken = false
		pc_fixed.emit(players_interacting, pc_id)
			 
@rpc("any_peer", "call_local")
func explode():
	broken = true
	stop_progress()
	var explosions = $Explosions.get_children()
	$DeathZone/CollisionShape2D.disabled = false
	for explosion:AnimatedSprite2D in explosions:
		explosion.show()
		explosion.play("boom")
		$ExplosionSound.play()
		explosion.animation_finished.connect(func() :
			explosion.hide()
		)
		await get_tree().create_timer(0.15).timeout
	pc_exploded.emit(players_in_death_zone)
	players_in_death_zone = []
	await get_tree().create_timer(0.8).timeout
	$DeathZone/CollisionShape2D.disabled = true
	

func _enter_area_behind_pc(body: Node2D) -> void:
	body.z_index -= 1


func _exit_area_behind_pc(body: Node2D) -> void:
	body.z_index += 1


func _on_death_zone_body_entered(body: Node2D) -> void:
	players_in_death_zone.append(body.id)


func _on_death_zone_body_exited(body: Node2D) -> void:
	players_in_death_zone.erase(body.id)
	
	
@rpc("any_peer", "call_local")
func fix_missing_part(part_name: String):
	var fixed = false
	match part_name:
		"ram":
			missing_ram = false
			fixed = true
			$Items/Center/RAM.hide()
			item_used.emit()
		"gpu":
			missing_gpu = false
			fixed = true
			$Items/Center/GPU.hide()
			item_used.emit()
		"hd":
			missing_hd = false
			fixed = true
			$Items/Center/HD.hide()
			item_used.emit()
		"cpu":
			missing_cpu = false
			fixed = true
			$Items/Center/CPU.hide()
			item_used.emit()
		"ssd":
			missing_cpu = false
			fixed = true
			$Items/Center/SSD.hide()
			item_used.emit()
			
	if fixed and not missing_gpu and not missing_hd and not missing_ram and not missing_cpu and not missing_ssd:
		var tween = create_tween()
		tween.tween_method(self.change_blink_intensity, 1.0, 0.0, 0.3)
		await tween.finished
		pc_fixed.emit(players_interacting, pc_id)
		broken = false
