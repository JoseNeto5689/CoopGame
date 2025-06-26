extends Node2D

signal trash_entered(player_id: int)
signal trash_exited(player_id: int)


func _on_area_2d_body_entered(body: Node2D) -> void:
	trash_entered.emit(body.id)


func _on_area_2d_body_exited(body: Node2D) -> void:
	trash_exited.emit(body.id)
