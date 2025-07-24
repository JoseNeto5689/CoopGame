extends Node2D

var time_elapsed: float = 0.0

func _process(delta: float) -> void:
	time_elapsed += delta
	print(format_time(time_elapsed))

func format_time(seconds: float) -> String:
	var whole = int(seconds)
	var decimals = int((seconds - whole) * 100)
	return "%d.%02d" % [whole, decimals]
