extends Timer

signal hazard_time

@export var number_of_hazards := 0
@export var game_duration := 0.0
var hazard_timepoints := []
var last_second = 0.0

func _ready() -> void:
	if (number_of_hazards == 0): 
		print("Error ao dividir por zero")
		return
	wait_time = game_duration
	var hazard_interval = snapped(game_duration / (number_of_hazards + 2.0), 0.01)
	for number in range(0, number_of_hazards):
		hazard_timepoints.append((number+1) * hazard_interval )
		
func _process(_delta: float) -> void:
	var actual_second = snapped(game_duration-time_left, 0.01)
	if(actual_second in hazard_timepoints and actual_second != last_second):
		hazard_time.emit()
		last_second = actual_second
		
	
