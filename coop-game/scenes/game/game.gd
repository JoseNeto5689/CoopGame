extends Node

@onready var map := $Map
@onready var players := $Players
@onready var ui := $UI

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




func _on_pc_player_entered_pc(id: int) -> void:
	if multiplayer.get_unique_id() == id:
		ui.visible = true


func _on_pc_player_exited_pc(id: int) -> void:
	if multiplayer.get_unique_id() == id:
		ui.visible = false
