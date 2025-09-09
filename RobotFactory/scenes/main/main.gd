extends Node

var game := preload("res://scenes/game/game.tscn")

func _close_network():
	print("Erro ao conectar")
	
func _connected():
	var id = str(multiplayer.get_unique_id())
	var player_name: String = $Control.player_name
	if player_name.is_empty():
		Global.addPlayer.rpc_id(1, id, str(id))
	else:
		Global.addPlayer.rpc_id(1, id, player_name)
	
func _disconnected():
	pass

func _ready() -> void:
	multiplayer.connection_failed.connect(_close_network)
	multiplayer.connected_to_server.connect(_connected)
	multiplayer.server_disconnected.connect(_disconnected)
	#multiplayer.peer_connected.connect(_peer_connected)
	
func _peer_connected(id: int):
	if Global.players.size() + 1 > Global.max_players:
		leave.rpc_id(id)

@rpc("any_peer", "call_local")
func leave():
	#Mensagem de players maximos atingidos
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null # Clear the peer to fully disconnect

func _enter_tree() -> void:
	multiplayer.multiplayer_peer = null

func _on_control_host_pressed(session: String) -> void:
	Global.session_code = session
	#Global.players = []
	var peer = WebSocketMultiplayerPeer.new()
	print("Iniciando servidor")
	multiplayer.multiplayer_peer = null
	peer.create_server(9999)
	multiplayer.multiplayer_peer = peer
	get_session(session)

func get_session(session):
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request("http://localhost:8000/api/sessions/by-session-code/" + session + "/", headers, HTTPClient.METHOD_GET)
	$HTTPRequest.request_completed.connect(func(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray):
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response = json.get_data()
		if response == null:
			$Control.disable_start()
			return
			
		$Control.enable_start()
		Global.duration = (response["session"]["duration"])
		Global.max_players = (response["session"]["max_participantes"])
	)

func _on_control_join_pressed() -> void:
	var peer = WebSocketMultiplayerPeer.new()
	multiplayer.multiplayer_peer = null
	print("Conectando ao servidor")
	peer.create_client("ws://" + "localhost"+ ":" + str(9999))
	multiplayer.multiplayer_peer = peer
	
func _on_control_start_pressed() -> void:
	if multiplayer.is_server():
		API.set_session_stats.rpc(Global.duration, Global.max_players)
	start_game.rpc()

@rpc("call_local", "any_peer")
func start_game():
	get_tree().change_scene_to_packed(game)
