extends Node
class_name Log

var player_id : int
var action : String
var timestamp : String

func _init(_player_id: int, _action: String) -> void:
	self.player_id = _player_id
	self.action = _action
	self.timestamp =  Time.get_datetime_string_from_unix_time(int(Time.get_unix_time_from_system()), true)
