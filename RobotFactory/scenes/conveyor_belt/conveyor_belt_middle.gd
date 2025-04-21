extends Node2D

func pause():
	var items = self.get_children()
	for item: AnimatedSprite2D in items: 
		item.pause()
		
func change_speed(speed: float):
	var items = self.get_children()
	for item: AnimatedSprite2D in items:
		item.speed_scale = speed

func resume():
	var items = self.get_children()
	for item: AnimatedSprite2D in items: 
		item.play()
