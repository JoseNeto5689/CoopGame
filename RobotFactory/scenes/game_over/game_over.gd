extends Control

func _on_go_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	

func _on_exit_game_pressed() -> void:
	get_tree().quit()
