extends Node2D

@export var flipped := false
var players_in_area := 0

func _ready() -> void:
	if flipped:
		$DangerZone.position.y = -$DangerZone.position.y

func _on_back_body_entered(_body: Node2D) -> void:
	$Pivot.rotation_degrees = -90 if not flipped else 90
	$DoorOpening.play()


func _on_front_body_entered(_body: Node2D) -> void:
	$Pivot.rotation_degrees = 90 if not flipped else -90
	$DoorOpening.play()


func _on_danger_zone_body_exited(_body: Node2D) -> void:
	players_in_area -= 1
	if players_in_area == 0:
		$Pivot.rotation_degrees = -0 if not flipped else 180
		$DoorClosing.play()


func _on_danger_zone_body_entered(_body: Node2D) -> void:
	players_in_area += 1
