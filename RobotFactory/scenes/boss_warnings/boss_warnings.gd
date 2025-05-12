extends Node2D


@onready var path := $Path2D
@onready var dialog := $Path2D/Boss/Label
@onready var sprite := $Path2D/Boss/Sprite2D

@export var walking_time := 0
@export var text_speed := 0.0

signal text_finished
signal concluded

	
func change_distance(value: Vector2):
	path.curve.set_point_position(1, value)

func slow_write(text: String, delay: float):
	dialog.text = ""
	for character in text.split(""):
		dialog.text += character
		if character != " ":
			await get_tree().create_timer(delay).timeout
	await get_tree().create_timer(4).timeout
	text_finished.emit()

func send(message: String):
	sprite.show()
	var tween = create_tween()
	sprite.play("walking")
	await tween.tween_property($Path2D/Boss, "progress_ratio", 1, walking_time).finished
	sprite.play("idle")
	slow_write(message, text_speed)
	await text_finished
	sprite.flip_h = true
	sprite.play("walking")
	dialog.text = ""
	tween = create_tween()
	await tween.tween_property($Path2D/Boss, "progress_ratio", 0, walking_time).finished
	sprite.hide()
	concluded.emit()
