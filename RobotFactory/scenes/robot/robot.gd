extends PathFollow2D

func change_sprite(new_sprite: String):
	$AnimatedSprite2D.play(new_sprite)

func change_blink_intensity(new_value: float):
	$AnimatedSprite2D.material.set_shader_parameter("blink_intensity", new_value)

func change_color(color: Color):
	$AnimatedSprite2D.material.set_shader_parameter("blink_color", color)

func add_shadow():
	change_color(Color.BLACK)
	change_blink_intensity(1)

func remove_shadow():
	change_color(Color.WHITE)
	change_blink_intensity(0)
