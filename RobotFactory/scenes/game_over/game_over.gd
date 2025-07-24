extends Control

var menu := preload("res://scenes/menu/menu.tscn")

func _on_go_to_menu_pressed() -> void:
	get_tree().change_scene_to_packed(menu)
	

func _on_exit_game_pressed() -> void:
	get_tree().quit()
