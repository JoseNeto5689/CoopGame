extends Node2D

signal pendrive_buyed



func _on_area_2d_body_entered(_body: Node2D) -> void:
	pendrive_buyed.emit()
