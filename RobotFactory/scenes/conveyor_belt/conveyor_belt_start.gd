extends Node2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func pause():
	animation.pause()
	
func change_speed(speed: float):
	animation.speed_scale = speed

func resume():
	animation.play()
