extends Node

var game := preload("res://scenes/game/game.tscn")

func _close_network():
	print("Erro ao conectar")
	
func _connected():
	var id = str(multiplayer.get_unique_id())
	var player_name = $Control.player_name
	Global.addPlayer.rpc_id(1, id, player_name)
	
func _disconnected():
	pass

func _ready() -> void:
	multiplayer.connection_failed.connect(_close_network)
	multiplayer.connected_to_server.connect(_connected)
	multiplayer.server_disconnected.connect(_disconnected)

func _on_control_host_pressed() -> void:
	var peer = WebSocketMultiplayerPeer.new()
	print("Iniciando servidor")
	multiplayer.multiplayer_peer = null
	peer.create_server(9999)
	multiplayer.multiplayer_peer = peer
	print(Global.players)
	

func _on_control_join_pressed() -> void:
	var peer = WebSocketMultiplayerPeer.new()
	multiplayer.multiplayer_peer = null
	print("Conectando ao servidor")
	peer.create_client("ws://" + "localhost"+ ":" + str(9999))
	multiplayer.multiplayer_peer = peer
	
func _on_control_start_pressed() -> void:
	start_game.rpc()

@rpc("call_local", "any_peer")
func start_game():
	get_tree().change_scene_to_packed(game)
