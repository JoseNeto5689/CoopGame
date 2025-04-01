extends Node

var players: Array = []

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
