extends Node

var players: Array = []
var robot_list = []

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
	robot_list.append("gun_robot_red")
	robot_list.append("claw_robot_red")
	robot_list.append("wing_robot_red")
	robot_list.append("ball_robot_red")
	
	var list = JSON.stringify(robot_list)
	send_robots_data.rpc(list)
	
@rpc("call_remote", "any_peer")
func send_robots_data(list: String):
	var json = JSON.new()
	json.parse(list)
	robot_list.append_array(json.data)
