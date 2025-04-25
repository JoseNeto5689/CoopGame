extends Node

var players: Array = []
var robot_list = []
var robot_status := RobotStats.new() 

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
	raw_list.append(["gun_robot_red",  2, 0, 0, 0, 0, 0])
	raw_list.append(["claw_robot_red", 0, 2, 0, 0, 0, 0])
	raw_list.append(["wing_robot_red", 1, 1, 0, 0, 0, 0])
	raw_list.append(["ball_robot_red", 1, 2, 0, 0, 0, 0])
	
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

func check_robot_stats(robot1 : RobotStats, robot2: RobotStats):
	if robot1.chaos == robot2.chaos and robot1.charisma == robot2.charisma and robot1.combat == robot2.combat and robot1.energy == robot2.energy and robot1.protection == robot2.protection and robot1.velocity == robot2.velocity:
		return true
	return false
