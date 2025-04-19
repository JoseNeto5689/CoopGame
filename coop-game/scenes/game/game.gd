extends Node

@onready var map := $Map
@onready var players := $Players
@onready var ui := $UI
@onready var computers := $Computers

func _ready() -> void:
	var player_preloaded = preload("res://scenes/player/player.tscn")
	var spawn_points: Array = map.get_spawn_points()
	var order = 0
	#Verificar se tamanho da lista de player bate com o tanto de spawn points
	for player in Global.players:
		var new_player = player_preloaded.instantiate()
		new_player.id = int(player.id)
		new_player.player_name = player.name
		new_player.spawn_position = spawn_points[order]
		order+=1
		players.add_child(new_player)
		

func _on_pc_player_entered_pc(id: int, pc_id: int) -> void:
	var player = find_player_by_id(id)
	if multiplayer.get_unique_id() == id:
		#Trocar por func de Ui
		ui.visible = true
		var computer = find_computer_by_id(pc_id)
		computer.show_progress_bar()
		player.interacting.connect(computer.increase_progress.rpc)
		player.stop_interacting.connect(computer.stop_progress.rpc)

func _on_pc_player_exited_pc(id: int, pc_id: int) -> void:
	var player = find_player_by_id(id)
	if multiplayer.get_unique_id() == id:
		#Trocar por func de Ui
		ui.visible = false
		var computer = find_computer_by_id(pc_id)
		computer.hide_progress_bar()
		player.interacting.disconnect(computer.increase_progress.rpc)
		player.stop_interacting.disconnect(computer.stop_progress.rpc)
		



func find_player_by_id(id: int) -> Node2D:
	var players_list = players.get_children()
	for player in players_list:
		if player.id == id:
			return player
	return null

func find_computer_by_id(id: int) -> Node2D:
	for computer in computers.get_children():
		if (computer.pc_id == id):
			return computer
	return null


func _on_pc_work_concluded(pc_id: int) -> void:
	print("Trabalho concluido no pc: "+ str(pc_id))
