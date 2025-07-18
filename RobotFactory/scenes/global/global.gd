extends Node

var players: Array = []
var robot_list = []
var robot_status := RobotStats.new()

var money := 20
var usb_stick_number := 1
var luck = 0

var status_list = []
var status_list_special = []

func _ready() -> void:
	RobotStats.new()
	status_list.append(["ball_robot_green",    0, 2, 0, 1, 0, 0])
	status_list.append(["ball_robot_orange",   0, 0, 2, 1, 0, 0])
	status_list.append(["ball_robot_purple",   0, 0, 0, 3, 0, 0])
	status_list.append(["ball_robot_red",      2, 0, 0, 1, 0, 0])
	status_list.append(["claw_robot_green",    0, 3, 0, 0, 0, 0])
	status_list.append(["claw_robot_orange",   0, 1, 2, 0, 0, 0])
	status_list.append(["claw_robot_purple",   0, 1, 0, 2, 0, 0])
	status_list.append(["claw_robot_red",      2, 1, 0, 0, 0, 0])
	status_list.append(["gun_robot_green",     1, 2, 0, 0, 0, 0])
	status_list.append(["gun_robot_orange",    1, 0, 2, 0, 0, 0])
	status_list.append(["gun_robot_purple",    1, 0, 0, 2, 0, 0])
	status_list.append(["gun_robot_red",       3, 0, 0, 0, 0, 0])
	status_list.append(["wing_robot_green",    0, 2, 1, 0, 0, 0])
	status_list.append(["wing_robot_orange",   0, 0, 3, 0, 0, 0])
	status_list.append(["wing_robot_purple",   0, 0, 1, 2, 0, 0])
	status_list.append(["wing_robot_red",      2, 0, 1, 0, 0, 0])
	
	status_list_special.append(["droid_basic", 3, 3, 3, 3, 0, 0])
	status_list_special.append(["mettaton",    2, 2, 2, 2, 0, 4])
	status_list_special.append(["metal_sonic", 2, 2, 2, 2, 4, 0])
	status_list_special.append(["bomb_robot",  5, 0, 0, 0, 0, 0])

signal usb_number_changed
signal money_changed


func get_robot_name(index: int):
	return Global.robot_list[index][0]

func get_robot_stats(index: int):
	return Global.robot_list[index][1]

@rpc("call_local", "any_peer")
func addPlayer(_id: String, _name: String):
	var player = Player.new(_id, _name)
	players.append(player)
	clearPlayers.rpc()
	for item in players:
		addPlayerRemote.rpc(item.id, item.name)

@rpc("any_peer", "call_remote")
func clearPlayers():
	players = []
	

@rpc("any_peer", "call_remote")
func addPlayerRemote(_id: String, _name: String):
	var player = Player.new(_id, _name)
	players.append(player)

func sync_robots():
	var raw_list = []
	
	if luck >= 5:
		raw_list.append(status_list_special.pick_random())
		luck=0
	else:
		raw_list.append(status_list.pick_random())
		luck+=1
	
	var list = JSON.stringify(raw_list)
	send_robots_data.rpc(list)
	
@rpc("call_local", "any_peer")
func send_robots_data(list: String):
	var json = JSON.new()
	json.parse(list)
	var list_raw = json.data
	for item in list_raw:
		robot_list.append([item[0], RobotStats.new(item[1], item[2], item[3], item[4], item[5], item[6])])

@rpc("any_peer", "call_local")
func update_robot_stats(pc_id: int):
	if pc_id == 0:
		robot_status = RobotStats.new()
	elif pc_id == 1:
		robot_status.combat += 1
	elif pc_id == 2:
		robot_status.protection += 1
	elif pc_id == 3:
		robot_status.velocity += 1
	elif pc_id == 4:
		robot_status.energy += 1
	elif pc_id == 5:
		robot_status.charisma += 1
		

func copy_robot_stats(robot_stats: RobotStats):
	var new_robot_stats = RobotStats.new()
	new_robot_stats.chaos = robot_stats.chaos
	new_robot_stats.combat = robot_stats.combat
	new_robot_stats.charisma = robot_stats.charisma
	new_robot_stats.energy = robot_stats.energy
	new_robot_stats.velocity = robot_stats.velocity
	new_robot_stats.protection = robot_stats.protection
	return new_robot_stats

@rpc("any_peer", "call_local")
func update_money(value: int):
	if multiplayer.is_server():
		money += value
		update_players_money.rpc(money)

@rpc("any_peer", "call_remote")
func update_players_money(value: int):
	money = value
	money_changed.emit()

@rpc("any_peer", "call_local")
func update_usb_stick_number(value: int):
	usb_number_changed.emit()
	usb_stick_number += value


func check_robot_stats(robot1 : RobotStats, robot2: RobotStats):
	if robot1.chaos == robot2.chaos and robot1.charisma == robot2.charisma and robot1.combat == robot2.combat and robot1.energy == robot2.energy and robot1.protection == robot2.protection and robot1.velocity == robot2.velocity:
		return true
	return false
