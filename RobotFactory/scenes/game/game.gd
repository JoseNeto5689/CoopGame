extends Node

@onready var map := $Map
@onready var players := $Players
@onready var ui := $CanvasLayer/UI
@onready var computers := $Computers

signal animation_concluded(status: bool)

var robot_index = 0

var in_animation = true

func _ready() -> void:
	var player_preloaded = preload("res://scenes/player/player.tscn")
	var spawn_points: Array = map.get_spawn_points()
	var order = 0
	for pc in $Computers.get_children():
		animation_concluded.connect(pc.animation_changed)
		
	#Verificar se tamanho da lista de player bate com o tanto de spawn points
	for player in Global.players:
		var new_player = player_preloaded.instantiate()
		new_player.id = int(player.id)
		new_player.player_name = player.name
		new_player.spawn_position = spawn_points[order]
		order+=1
		players.add_child(new_player)
	
	if multiplayer.is_server():
		Global.sync_robots()
		
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
	var computer = find_computer_by_id(pc_id)
	computer.reset.rpc()
	Global.update_robot_stats(pc_id)
	if (Global.check_robot_stats(Global.robot_list[robot_index - 1][1])):
		Global.update_robot_stats(0)
		$ConveyorBelt.spawn_robot(Global.robot_list[robot_index][0])
		robot_index+=1
	

func _on_timer_timeout() -> void:
	$ConveyorBelt.spawn_robot(Global.robot_list[robot_index][0])
	robot_index+=1
	


func _on_conveyor_belt_animation_concluded() -> void:
	animation_concluded.emit(true)


func _on_conveyor_belt_animation_started() -> void:
	animation_concluded.emit(false)
