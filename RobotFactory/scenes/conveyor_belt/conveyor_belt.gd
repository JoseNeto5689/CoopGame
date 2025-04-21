extends Node2D

func pause():
	var items = get_children()
	for item in items:
		item.pause()

func change_speed(speed: float):
	var items = self.get_children()
	for item in items:
		item.change_speed(speed)

func resume():
	var items = self.get_children()
	for item in items: 
		item.resume()
