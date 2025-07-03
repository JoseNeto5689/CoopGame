extends Node2D

@export var flipped := false

func _ready() -> void:
	if flipped:
		$DangerZone.position.y = -$DangerZone.position.y

func _on_back_body_entered(_body: Node2D) -> void:
	$Pivot.rotation_degrees = -90 if not flipped else 90


func _on_front_body_entered(_body: Node2D) -> void:
	$Pivot.rotation_degrees = 90 if not flipped else -90


func _on_danger_zone_body_exited(_body: Node2D) -> void:
	$Pivot.rotation_degrees = -0 if not flipped else 180
