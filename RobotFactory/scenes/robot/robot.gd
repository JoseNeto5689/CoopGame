extends PathFollow2D

func change_sprite(new_sprite: String):
	$AnimatedSprite2D.play(new_sprite)

func change_blink_intensity(new_value: float):
	$AnimatedSprite2D.material.set_shader_parameter("blink_intensity", new_value)
