extends Node2D

@onready var pb_atk_1 := $Control/Attack/ProgressBar
@onready var pb_atk_2 := $Control/Attack/ProgressBar2

@onready var pb_def_1 := $Control/Defense/ProgressBar
@onready var pb_def_2 := $Control/Defense/ProgressBar2

@onready var pb_spd_1 := $Control/Speed/ProgressBar
@onready var pb_spd_2 := $Control/Speed/ProgressBar2

@onready var pb_eng_1 := $Control/Energy/ProgressBar
@onready var pb_eng_2 := $Control/Energy/ProgressBar2

@onready var pb_cha_1 := $Control/Charisma/ProgressBar
@onready var pb_cha_2 := $Control/Charisma/ProgressBar2

@onready var pb_ran_1 := $Control/Chaos/ProgressBar
@onready var pb_ran_2 := $Control/Chaos/ProgressBar2

func set_robot_status(robot_status: RobotStats):
	pb_atk_1.value = robot_status.combat
	pb_def_1.value = robot_status.protection
	pb_spd_1.value = robot_status.velocity
	pb_eng_1.value = robot_status.energy
	pb_cha_1.value = robot_status.charisma
	pb_ran_1.value = robot_status.chaos
	
func set_robot_progress(robot_status: RobotStats):
	pb_atk_2.value = robot_status.combat
	pb_def_2.value = robot_status.protection
	pb_spd_2.value = robot_status.velocity
	pb_eng_2.value = robot_status.energy
	pb_cha_2.value = robot_status.charisma
	pb_ran_2.value = robot_status.chaos
