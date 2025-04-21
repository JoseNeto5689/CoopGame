extends Node

var speed := 1
var progress := 0.06

var robot := preload("res://scenes/robot/robot.tscn")

var actual_robot : PathFollow2D
var last_robot :PathFollow2D

var stopped = false
var restart = false

func spawn_robot(robot_sprite: String):
	if actual_robot:
		last_robot = actual_robot
		restart = true
		stopped = false
	var spawned_robot = robot.instantiate()
	spawned_robot.change_sprite(robot_sprite)
	$LineProduction.add_child(spawned_robot)
	actual_robot = spawned_robot
	
	
func _physics_process(delta: float) -> void:
	if restart:
		$Animation.play("restart")
		restart = false
	if actual_robot and actual_robot.progress_ratio >= 0.46 and not stopped:
		$Animation.play("stop") 
		stopped = true
	if last_robot and last_robot.progress_ratio >= 0.99:
		last_robot.queue_free()
	if last_robot:
		last_robot.progress_ratio += progress * delta
	if actual_robot:
		actual_robot.progress_ratio += progress * delta
	$ConveyorBelt.change_speed(speed)
