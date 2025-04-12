extends PathFollow2D

@export var progress_number: float = 0.0  

func _physics_process(delta: float) -> void:
	if not progress_ratio >= 0.5:
		progress_ratio += progress_number * delta
		progress = int(progress)
