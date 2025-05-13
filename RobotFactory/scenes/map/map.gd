extends Node2D

@onready var spawn_points := $SpawnPoints

func _ready() -> void:
	get_map_limits()

func get_spawn_points(): 
	var positions := []
	var children = spawn_points.get_children()
	for item: Marker2D in children:
		positions.append(item.position)
	return positions
	
func get_map_limits():
	var limits = []
	limits.append(10)
	limits.append(0)
	limits.append($Walls.tile_set.tile_size.x * $Walls.get_used_rect().size.x - 10)
	limits.append($Walls.tile_set.tile_size.y * $Walls.get_used_rect().size.y - 10)
	return limits
