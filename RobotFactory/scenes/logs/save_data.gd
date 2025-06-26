extends Node

func clear_logs():
	if FileAccess.file_exists("user://savelog.save"):
		var file = FileAccess.open("user://savelog.save", FileAccess.WRITE)
		file.store_string("")

func save_log(logs: Log):
	var logs_list = []
	if FileAccess.file_exists("user://savelog.save"):
		var file = FileAccess.open("user://savelog.save", FileAccess.READ)
		var content = file.get_as_text()
		if content != "":
			var parsed = JSON.parse_string(content)
			logs_list = parsed

	logs_list.append({
		"player_id": logs.player_id,
		"action": logs.action,
		"timestamp": logs.timestamp
	})

	var save_file = FileAccess.open("user://savelog.save", FileAccess.WRITE)
	save_file.store_string(JSON.stringify(logs_list, "\t")) 

func read_logs() -> String:
	if FileAccess.file_exists("user://savelog.save"):
		var file = FileAccess.open("user://savelog.save", FileAccess.READ)
		return file.get_as_text()
	return ""
