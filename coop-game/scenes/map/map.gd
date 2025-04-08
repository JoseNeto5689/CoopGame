extends Node2D

@onready var spawn_points := $SpawnPoints

func get_spawn_points(): 
	var positions := []
	var children = spawn_points.get_children()
	for item: Marker2D in children:
		positions.append(item.position)
	return positions
	
