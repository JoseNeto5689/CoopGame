extends Control

signal host_pressed(session: String)
signal join_pressed
signal start_pressed

var player_name: String
var session_id: String


func enable_start():
	$CenterContainer/HBoxContainer/VBoxContainer2/Start.disabled = false

func disable_start():
	$CenterContainer/HBoxContainer/VBoxContainer2/Start.disabled = true

func _on_host_pressed() -> void:
	host_pressed.emit(%Session.text)


func _on_join_pressed() -> void:
	join_pressed.emit()


func _on_start_pressed() -> void:
	start_pressed.emit()


func _on_input_text_changed(new_text: String) -> void:
	player_name = new_text

func _on_session_changed(new_text: String) -> void:
	session_id = new_text
