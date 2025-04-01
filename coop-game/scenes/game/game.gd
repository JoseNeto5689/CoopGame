extends Node

func _ready() -> void:
	var player_preloaded = preload("res://scenes/player/player.tscn")
	var num = 0
	for player in Global.players:
		var new_player = player_preloaded.instantiate()
		new_player.spawn_position = Vector2(0, num)
		num += 50
		new_player.id = int(player.id)
		new_player.player_name = player.name
		add_child(new_player)
