extends Node

@onready var map := $Map
@onready var players := $Players
@onready var ui := $UI
@onready var computers := $Computers

signal animation_concluded(status: bool)

var robot_index = 0

var in_animation = true
	
func _ready() -> void:
	Global.usb_number_changed.connect(ui.update_pendrive.rpc)
	Global.money_changed.connect(ui.update_money.rpc)
	
	if multiplayer.is_server():
		ui.hide_hud()
	
	var player_preloaded = preload("res://scenes/player/player.tscn")
	var spawn_points: Array = map.get_spawn_points()
	for pc in $Computers.get_children():
		animation_concluded.connect(pc.animation_changed)
	#Verificar se tamanho da lista de player bate com o tanto de spawn points
	var order = 0
	for player in Global.players:
		var new_player = player_preloaded.instantiate()
		new_player.id = int(player.id)
		new_player.player_name = player.name
		new_player.spawn_position = spawn_points[order]
		order+=1
		players.add_child(new_player)
	
	for player in $Players.get_children():
		player.given_usb_stick.connect(check_robot_in_conveyor_belt)
		animation_concluded.connect(player.set_animation_status)
	
	if multiplayer.is_server():
		Global.sync_robots()
		
func _on_pc_player_entered_pc(id: int, pc_id: int) -> void:
	var player = find_player_by_id(id)
	if multiplayer.get_unique_id() == id:
		#Trocar por func de Ui
		ui.show_interact()
		var computer = find_computer_by_id(pc_id)
		computer.show_progress_bar()
		if (computer.broken and player.current_item == "toolkit"):
			player.interacting.connect(computer.fix_pc.rpc)
			computer.item_used.connect(player.clear_item.rpc)
			computer.pc_fixed.connect(swap_interaction.rpc)
		else:
			player.interacting.connect(computer.increase_progress.rpc)
			player.stop_interacting.connect(computer.stop_progress.rpc)
			

@rpc("any_peer", "call_local")
func swap_interaction(players_interacting: Array, computer_id):
	var computer = find_computer_by_id(computer_id)
	for player_id in players_interacting:
		var player = find_player_by_id(player_id)
		if not player.interacting.is_connected(computer.increase_progress.rpc):
			player.interacting.connect(computer.increase_progress.rpc)
			player.stop_interacting.connect(computer.stop_progress.rpc)
		if player.interacting.is_connected(computer.fix_pc.rpc):
			player.interacting.disconnect(computer.fix_pc.rpc)
			computer.item_used.disconnect(player.clear_item.rpc)
			computer.pc_fixed.disconnect(swap_interaction.rpc)
			
			

func _on_pc_player_exited_pc(id: int, pc_id: int) -> void:
	var player = find_player_by_id(id)
	if multiplayer.get_unique_id() == id:
		#Trocar por func de Ui
		ui.hide_interact()
		var computer = find_computer_by_id(pc_id)
		computer.hide_progress_bar()
		if (player.interacting.is_connected(computer.fix_pc.rpc)):
			player.interacting.disconnect(computer.fix_pc.rpc)
			computer.item_used.disconnect(player.clear_item.rpc)
			computer.pc_fixed.disconnect(swap_interaction.rpc)
		elif player.interacting.is_connected(computer.fix_pc.rpc):
			player.interacting.disconnect(computer.fix_pc.rpc)
			computer.item_used.disconnect(player.clear_item.rpc)
			computer.pc_fixed.disconnect(swap_interaction.rpc)
		else:
			player.interacting.disconnect(computer.increase_progress.rpc)
			player.stop_interacting.disconnect(computer.stop_progress.rpc)
		

func _on_pc_work_concluded(pc_id: int) -> void:
	var computer = find_computer_by_id(pc_id)
	computer.reset.rpc()
	computer.explode()
	Global.update_robot_stats(pc_id)

func _on_timer_timeout() -> void:
	$ConveyorBelt.spawn_robot(Global.get_robot_name(robot_index))
	robot_index+=1
	

func _on_conveyor_belt_animation_concluded() -> void:
	in_animation = false
	animation_concluded.emit(true)


func _on_conveyor_belt_animation_started() -> void:
	in_animation = true
	animation_concluded.emit(false)


func _on_player_enter_deployer_area(player_id: int) -> void:
	var player = find_player_by_id(player_id)
	player.interacting.connect(player.interact_with_deployer.rpc)

func _on_player_exit_deployer_area(player_id) -> void:
	var player = find_player_by_id(player_id)
	if player.interacting.is_connected(player.interact_with_deployer.rpc):
		player.interacting.disconnect(player.interact_with_deployer.rpc)


func _on_enter_robot_area(body: Node2D) -> void:
	var player = find_player_by_id(body.id)
	player.interacting.connect(player.give_item.rpc)
	
func _on_exit_robot_area(body: Node2D) -> void:
	var player = find_player_by_id(body.id)
	player.interacting.disconnect(player.give_item.rpc)
	

func check_robot_in_conveyor_belt(robot_stats: RobotStats):
	Global.update_robot_stats(0)
	if Global.check_robot_stats(robot_stats, Global.get_robot_stats(robot_index - 1)):
		$ConveyorBelt.robot_ok()
		$ConveyorBelt.spawn_robot(Global.get_robot_name(robot_index))
		Global.update_money(+10)
		robot_index+=1

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


func _on_market_item_buyed(item: String, player_id: int, value: int) -> void:
	if Global.money < value or in_animation:
		return
	Global.update_money(-value)
	var player = find_player_by_id(player_id)
	player.get_item.rpc(item)
