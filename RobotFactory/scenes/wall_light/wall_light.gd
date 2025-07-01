extends Node2D

@export var noise: NoiseTexture2D
var time_passed := 0.0


func _process(delta: float) -> void:
	time_passed += delta
	var sampled_noise = noise.noise.get_noise_1d(time_passed)
	var energy = 0.65 + abs(sampled_noise/2)
	$PointLight2D.energy = energy
	if randi_range(1, 1500) < 5:
		$PointLight2D.energy = 0
