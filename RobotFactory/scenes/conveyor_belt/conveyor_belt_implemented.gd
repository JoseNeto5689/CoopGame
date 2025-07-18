extends Node

var speed := 1
var progress := 0.06

var robot := preload("res://scenes/robot/robot.tscn")

var actual_robot : PathFollow2D
var last_robot :PathFollow2D

var stopped = false
var restart = false
var is_dark = false

signal animation_started
signal animation_concluded

func change_to_dark_scene():
	is_dark = true

func spawn_robot(robot_sprite: String):
	if actual_robot:
		last_robot = actual_robot
		restart = true
		stopped = false
	var spawned_robot = robot.instantiate()
	spawned_robot.change_sprite(robot_sprite)
	if is_dark:
		spawned_robot.add_shadow()
	$LineProduction.add_child(spawned_robot)
	actual_robot = spawned_robot
	if multiplayer.is_server():
		Global.sync_robots()
	
	
func _process(delta: float) -> void:
	if restart:
		$Animation.play("restart")
		restart = false
	if actual_robot and actual_robot.progress_ratio >= 0.46 and not stopped:
		$Animation.play("stop")
		stopped = true
	if last_robot and last_robot.progress_ratio >= 0.99:
		last_robot.queue_free()
	if last_robot:
		last_robot.progress_ratio += (progress * delta)
	if actual_robot:
		actual_robot.progress_ratio += (progress * delta)
	$ConveyorBelt.change_speed(speed)


func _on_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "stop":
		actual_robot.progress_ratio = str(actual_robot.progress_ratio, 1).to_float()
		animation_concluded.emit()


func _on_animation_animation_started(anim_name: StringName) -> void:
	if anim_name == "stop" or anim_name == "restart":
		animation_started.emit()

func robot_ok():
	actual_robot.remove_shadow()
	var tween = create_tween()
	tween.tween_method(actual_robot.change_blink_intensity, 1.0, 0.0, 0.3)
