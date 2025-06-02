extends Node

@onready var map := $Map
@onready var players := $Players
@onready var ui := $UI
@onready var computers := $Computers

signal animation_concluded(status: bool)

var robot_index = 0

var in_animation = true
var is_dark := false
	
func _ready() -> void:
	Global.usb_number_changed.connect(ui.update_pendrive.rpc)
	Global.usb_number_changed.connect($Deployer.check_usb_number.rpc)
	Global.money_changed.connect(ui.update_money.rpc)
	
	if multiplayer.is_server():
		ui.hide_hud()
	
	var player_preloaded = preload("res://scenes/player/player.tscn")
	var spawn_points: Array = map.get_spawn_points()
	var limits = map.get_map_limits()
	for pc in $Computers.get_children():
		animation_concluded.connect(pc.animation_changed)
		pc.pc_exploded.connect(kill_players)
	#Verificar se tamanho da lista de player bate com o tanto de spawn points
	var order = 0
	for player in Global.players:
		var new_player = player_preloaded.instantiate()
		new_player.id = int(player.id)
		new_player.player_name = player.name
		new_player.spawn_position = spawn_points[order]
		new_player.update_camera_limits(limits)
		order+=1
		players.add_child(new_player)
	
	for player in $Players.get_children():
		player.given_usb_stick.connect(check_robot_in_conveyor_belt)
		animation_concluded.connect(player.set_animation_status)
		player.player_entered_heal_zone.connect(player_entered_heal_zone)
		player.player_exited_heal_zone.connect(player_exited_heal_zone)
	
	animation_concluded.connect($ButtonNext.animation_changed)
	$Deployer.finished.connect(_on_deployer_finished)
	
	if multiplayer.is_server():
		Global.sync_robots()
		
func player_entered_heal_zone(dead_player_id: int, player_id: int):
	var dead_player = find_player_by_id(dead_player_id)
	var player = find_player_by_id(player_id)
	player.interacting.connect(player.heal_player.rpc)
	player.healing_player.connect(dead_player.revive.rpc)
	
func player_exited_heal_zone(dead_player_id: int, player_id: int):
	var dead_player = find_player_by_id(dead_player_id)
	var player = find_player_by_id(player_id)
	player.interacting.disconnect(player.heal_player.rpc)
	player.healing_player.disconnect(dead_player.revive.rpc)

func _on_pc_player_entered_pc(id: int, pc_id: int) -> void:
	var player = find_player_by_id(id)
	if multiplayer.get_unique_id() == id:
		#Trocar por func de Ui
		ui.show_interact()
		var computer = find_computer_by_id(pc_id)
		computer.show_progress_bar()
		if (computer.broken and player.current_item == "toolkit" and not computer.missing_ram and not computer.missing_gpu and not computer.missing_hd):
			player.interacting.connect(computer.fix_pc.rpc)
			computer.item_used.connect(player.clear_item.rpc)
			computer.pc_fixed.connect(swap_interaction.rpc)
		elif (computer.missing_ram and player.current_item == "ram") or (computer.missing_gpu and player.current_item == "gpu") or (computer.missing_hd and player.current_item == "hd"):
			player.interacting.connect(computer.fix_missing_part.rpc)
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
		if player.interacting.is_connected(computer.fix_missing_part.rpc):
			player.interacting.disconnect(computer.fix_missing_part.rpc)
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
		elif player.interacting.is_connected(computer.fix_missing_part.rpc):
			player.interacting.disconnect(computer.fix_missing_part.rpc)
			computer.item_used.disconnect(player.clear_item.rpc)
			computer.pc_fixed.disconnect(swap_interaction.rpc)
		else:
			computer.stop_progress.rpc()
			player.interacting.disconnect(computer.increase_progress.rpc)
			player.stop_interacting.disconnect(computer.stop_progress.rpc)
		

func _on_pc_work_concluded(pc_id: int) -> void:
	var computer = find_computer_by_id(pc_id)
	computer.reset.rpc()
	if pc_id ==2:
		computer.explode()
	Global.update_robot_stats(pc_id)
	$StatusTelevision.set_robot_progress(Global.robot_status)

func _on_timer_timeout() -> void:
	#$BossWarnings.send("Trabalhem pilantras")
	#await $BossWarnings.concluded
	$ConveyorBelt.spawn_robot(Global.get_robot_name(robot_index))
	$StatusTelevision.set_robot_status(Global.get_robot_stats(robot_index))
	robot_index+=1
	

func _on_conveyor_belt_animation_concluded() -> void:
	in_animation = false
	animation_concluded.emit(true)


func _on_conveyor_belt_animation_started() -> void:
	in_animation = true
	animation_concluded.emit(false)


func _on_player_enter_deployer_area(player_id: int) -> void:
	if multiplayer.get_unique_id() == player_id:
		var player = find_player_by_id(player_id)
		player.interacting.connect(player.interact_with_deployer.rpc)
		player.usb_stick_given.connect($Deployer.play_loading_data_animation.rpc)

func _on_deployer_finished(player_id):
	if multiplayer.is_server():
		var player = find_player_by_id(player_id)
		player.finish_deployer_transfer.rpc()

func _on_player_exit_deployer_area(player_id) -> void:
	var player = find_player_by_id(player_id)
	if player.interacting.is_connected(player.interact_with_deployer.rpc):
		player.interacting.disconnect(player.interact_with_deployer.rpc)
		player.usb_stick_given.disconnect($Deployer.play_loading_data_animation.rpc)

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
		$StatusTelevision.set_robot_progress(RobotStats.new())
		$StatusTelevision.set_robot_status(Global.get_robot_stats(robot_index))
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
	var player = find_player_by_id(player_id)
	if Global.money >= value and not in_animation and not player.has_item:
		Global.update_money(-value)
		if item == "coffe":
			increase_player_speed.rpc()
			return
		elif item == "wifi":
			reduce_computer_time.rpc()
			return
		player.get_item(item)
	return

@rpc("any_peer", "call_local")
func increase_player_speed():
	for player in $Players.get_children():
		player.SPEED += 20
		
@rpc("any_peer", "call_local")
func reduce_computer_time():
	for computer in $Computers.get_children():
		computer.reduce_speed(1)
		

func _on_button_next_player_entered_button_area(player_id: int) -> void:
	var player = find_player_by_id(player_id)
	player.interacting.connect($ButtonNext.button_pressed.rpc)


func _on_button_next_button_has_been_pressed() -> void:
	$ConveyorBelt.spawn_robot(Global.get_robot_name(robot_index))
	robot_index+=1


func _on_button_next_player_exited_button_area(player_id: int) -> void:
	var player = find_player_by_id(player_id)
	player.interacting.disconnect($ButtonNext.button_pressed.rpc)

func kill_players(list: Array):
	for player_id in list:
		var player = find_player_by_id(player_id)
		player.die()


func _on_hazard_release() -> void:
	pass
	#if multiplayer.is_server():
		#if not is_dark:
			#become_dark.rpc()
		#else:
			#return_to_light.rpc()
			
@rpc("any_peer", "call_local")
func explode_random_pc() -> bool:
	var local_computers := []
	for computer in $Computers.get_children():
		if not computer.broken:
			local_computers.append(computer.pc_id)
	if local_computers.size() == 0:
		print("Todos os computadores estao quebrados")
		return false
	var random_id = randi_range(0, local_computers.size()-1)
	var computer = find_computer_by_id(local_computers[random_id])
	computer.explode()
	return true

@rpc("any_peer", "call_local")
func become_dark() -> bool:
	if is_dark:
		return false
	is_dark = true
	var tween = create_tween()
	await tween.tween_property($CanvasModulate, "color", Color(0.05, 0.05, 0.05), 1).finished
	await get_tree().create_timer(0.5).timeout
	for player in $Players.get_children():
		player.turn_on_lights()
	await get_tree().create_timer(0.5).timeout
	$Lights.show()
	return true
	
@rpc("any_peer", "call_local")
func return_to_light() -> bool:
	if not is_dark:
		return false
	is_dark = false
	for player in $Players.get_children():
		player.turn_off_lights()
	$Lights.hide()
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", Color(1,1,1), 3)
	return true


func _on_engineer_player_start_interact(player_id: int, item: String) -> void:
	var player = find_player_by_id(player_id)
	if item == player.current_item:
		player.interacting.connect(upgrade_random_pc_server.rpc)
		player.interacting.connect(player.reset_item.rpc)
		player.interacting.connect(reset_engineer.rpc)

@rpc("any_peer", "call_remote")
func upgrade_random_pc_server(_item):
	if multiplayer.is_server():
		var random_id = randi_range(1, 4)
		upgrade_random_pc_local.rpc(random_id)

@rpc("any_peer", "call_local")
func upgrade_random_pc_local(id):
	var computer = find_computer_by_id(id)
	computer.reduce_speed(0.5)

@rpc("any_peer", "call_local")
func reset_engineer(_item):
	$Engineer.change_item_needed("")

func _on_engineer_player_stop_interact(player_id: int, item: String) -> void:
	var player = find_player_by_id(player_id)
	if player.interacting.is_connected(upgrade_random_pc_server.rpc):
		player.interacting.disconnect(upgrade_random_pc_server.rpc)
		player.interacting.disconnect(player.reset_item.rpc)
		player.interacting.disconnect(reset_engineer.rpc)
