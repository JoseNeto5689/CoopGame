extends Node2D

signal enter_deployer_area(player_id)
signal exit_deployer_area(player_id)

func _on_area_2d_body_entered(body: Node2D) -> void:
	enter_deployer_area.emit(body.id)


func _on_area_2d_body_exited(body: Node2D) -> void:
	exit_deployer_area.emit(body.id)
