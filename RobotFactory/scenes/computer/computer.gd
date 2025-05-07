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

var tween_turning_off : Tween

var is_animation_concluded := false
var working := false
var concluded := false
var broken := false

func _ready() -> void:
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

func _on_area_2d_body_exited(body: Node2D) -> void:
	if "id" in body:
		player_exited_pc.emit(body.id, pc_id)

func _on_timer_timeout() -> void:
	concluded = true
	work_concluded.emit(pc_id)

@rpc("any_peer", "call_local")
func increase_progress():
	if is_animation_concluded and not broken:
		#$PointLight2D.enabled = true
		if(get_percentage() == 0):
			change_progress(0)
		working = true
		
		if tween_turning_off:
			tween_turning_off.kill()
			
		pc_sprite.texture = texture_on
	
@rpc("any_peer", "call_local")
func stop_progress():
	#$PointLight2D.enabled = false
	working = false
	timer.paused = true
	tween_turning_off = create_tween()
	tween_turning_off.tween_property(pc_sprite, "texture", texture_off, 0.2)

@rpc("any_peer", "call_local")
func reset():
	working = false
	concluded = false

func animation_changed(status: bool):
	is_animation_concluded = status

func change_blink_intensity(new_value: float):
	$ComputerSprite.material.set_shader_parameter("blink_intensity", new_value)

func fix_pc():
	broken = false
	var tween = create_tween()
	tween.tween_method(change_blink_intensity, 1.0, 0.0, 0.3)

func explode():
	broken = true
	stop_progress()
	var explosions = $Explosions.get_children()
	for explosion:AnimatedSprite2D in explosions:
		explosion.show()
		explosion.play("boom")
		explosion.animation_finished.connect(func() :
			explosion.hide()
		)
		await get_tree().create_timer(0.15).timeout 
