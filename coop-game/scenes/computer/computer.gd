extends Node2D

signal player_entered_pc(id: int)
signal player_exited_pc(id: int)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "id" in body:
		player_entered_pc.emit(body.id)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if "id" in body:
		player_exited_pc.emit(body.id)
