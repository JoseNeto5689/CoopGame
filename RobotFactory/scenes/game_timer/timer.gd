extends Timer

signal hazard_time
signal upgrade_time

@export var number_of_hazards := 0
@export var number_of_upgrades := 0
@export var game_duration := 0.0
var hazard_timepoints := []
var upgrade_timepoints := []
var last_second_hazard = 0.0
var last_second_upgrade = 0.0


func get_minutes():
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	minutes = str(minutes) if minutes / 10 >= 1 else "0" + str(minutes)
	seconds = str(seconds) if seconds / 10 >= 1 else "0" + str(seconds)
	$CanvasLayer/Control/RichTextLabel.text = "%s:%s" % [minutes, seconds]

func _ready() -> void:
	if (number_of_hazards == 0): 
		print("Error ao dividir por zero")
		return
	wait_time = game_duration
	var hazard_interval = snapped(game_duration / (number_of_hazards + 2.0), 0.01)
	var upgrade_interval = snapped(game_duration / (number_of_upgrades + 2.0), 0.01)
	for number in range(0, number_of_hazards):
		hazard_timepoints.append((number+1) * hazard_interval )
	for number in range(0, number_of_upgrades):
		upgrade_timepoints.append((number+1) * upgrade_interval )
		
func _process(_delta: float) -> void:
	get_minutes()
	var actual_second = snapped(game_duration-time_left, 0.01)
	if(actual_second in hazard_timepoints and actual_second != last_second_hazard):
		hazard_time.emit()
		last_second_hazard = actual_second
	if(actual_second in upgrade_timepoints and actual_second != last_second_upgrade):
		upgrade_time.emit()
		last_second_upgrade = actual_second
		
	
