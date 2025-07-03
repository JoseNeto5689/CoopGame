extends Control

signal host_pressed
signal join_pressed
signal start_pressed

var player_name: String
var session_id: String

func _on_host_pressed() -> void:
	host_pressed.emit()


func _on_join_pressed() -> void:
	join_pressed.emit()


func _on_start_pressed() -> void:
	start_pressed.emit()


func _on_input_text_changed(new_text: String) -> void:
	player_name = new_text

func _on_session_changed(new_text: String) -> void:
	session_id = new_text
