extends PathFollow2D

func change_sprite(new_sprite: String):
	$AnimatedSprite2D.play(new_sprite)
