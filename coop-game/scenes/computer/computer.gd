extends Node2D

@export var pc_id := 0
@export var time_for_conclude := 0

@onready var progress_bar := $ProgressBar
@onready var timer := $Timer

signal player_entered_pc(id: int, pc_id: int)
signal player_exited_pc(id: int, pc_id: int)

var working = false
var concluded = false

func _ready() -> void:
	timer.wait_time = time_for_conclude
	
func _process(_delta: float) -> void:
	if(working and not concluded):
		if(timer.is_stopped()):
			timer.start()
		timer.paused = false
		var percentage := get_percentage()
		change_progress(percentage)

func change_progress(value: int): 
	progress_bar.value = value
	
@rpc("any_peer", "call_local")
func increase_progress():
	working = true
	
@rpc("any_peer", "call_local")
func stop_progress():
	working = false
	timer.paused = true

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
