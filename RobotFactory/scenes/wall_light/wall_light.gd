extends Node2D

@export var noise: NoiseTexture2D
var time_passed := 0.0


func _process(delta: float) -> void:
	time_passed += delta
	var sampled_noise = noise.noise.get_noise_1d(time_passed)
	$PointLight2D.energy = 0.6 + abs(sampled_noise)
	if randi_range(1, 1000) < 5:
		$PointLight2D.energy = 0
