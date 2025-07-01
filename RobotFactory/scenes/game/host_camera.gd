extends Camera2D

var buttons_pressed = []

func get_direction() -> Vector2:
	if (Input.is_action_just_pressed("up")):
		buttons_pressed.append(Vector2(0,-1))
	if (Input.is_action_just_pressed("down")):
		buttons_pressed.append(Vector2(0,1))
	if (Input.is_action_just_pressed("left")):
		buttons_pressed.append(Vector2(-1,0))
	if (Input.is_action_just_pressed("right")):
		buttons_pressed.append(Vector2(1,0))
	
	if (Input.is_action_just_released("up")):
		buttons_pressed.erase(Vector2(0,-1))
	if (Input.is_action_just_released("down")):
		buttons_pressed.erase(Vector2(0,1))
	if (Input.is_action_just_released("left")):
		buttons_pressed.erase(Vector2(-1,0))
	if (Input.is_action_just_released("right")):
		buttons_pressed.erase(Vector2(1,0))
	
	if(buttons_pressed.is_empty()):
		return Vector2.ZERO
	return buttons_pressed[0]
	
	
func _process(delta: float) -> void:
	if not multiplayer.is_server():
		return
	var direction = get_direction()
	position.x += direction.x * delta * 200
	position.y += direction.y * delta * 200
