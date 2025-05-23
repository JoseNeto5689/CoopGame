extends Node2D

signal enter_deployer_area(player_id)
signal exit_deployer_area(player_id)

signal finished

@onready var sprites := $Sprites

func _on_area_2d_body_entered(body: Node2D) -> void:
	enter_deployer_area.emit(body.id)
	await get_tree().create_timer(0.1).timeout
	sprites.play("add_pendrive")

func _on_area_2d_body_exited(body: Node2D) -> void:
	exit_deployer_area.emit(body.id)
	await get_tree().create_timer(0.1).timeout
	sprites.play("default")

@rpc("any_peer", "call_local")
func play_loading_data_animation():
	sprites.play("loading_data")
	await get_tree().create_timer(2.5).timeout
	sprites.play("default")
	if multiplayer.is_server():
		finished.emit()
