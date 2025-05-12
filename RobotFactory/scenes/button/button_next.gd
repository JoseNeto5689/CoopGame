extends Node2D

@export var button_not_pressed_sprite : CompressedTexture2D
	
@export var button_pressed_sprite : CompressedTexture2D

@onready var image := $Sprite2D

signal player_entered_button_area(player_id: int)
signal player_exited_button_area(player_id: int)
signal button_has_been_pressed

var is_animation_concluded := false

func animation_changed(status: bool):
	is_animation_concluded = status

func button_press(pressed: bool):
	if pressed:
		image.texture = button_pressed_sprite
	else:
		image.texture = button_not_pressed_sprite


func _on_button_area_body_entered(body: Node2D) -> void:
	player_entered_button_area.emit(body.id)

@rpc("any_peer", "call_local")
func button_pressed():
	if(is_animation_concluded):
		button_press(true)
		button_has_been_pressed.emit()
		await get_tree().create_timer(0.3).timeout 
		button_press(false)

func _on_button_area_body_exited(body: Node2D) -> void:
	player_exited_button_area.emit(body.id)
