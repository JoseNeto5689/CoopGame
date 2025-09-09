extends Node

var url_send = "http://localhost:8000/api/results/"
var url_player = "http://localhost:8000/api/players/by-session-code/"
var url_session = "http://localhost:8000/api/sessions/by-session-code/"

#func send_log(logs: Log):
	#if multiplayer.is_server():
		#var requests = HTTPRequest.new()
		#add_child(requests)
		#var headers = ["Content-Type: application/json"]
		#var request_body = JSON.stringify({
			#"session": "4679C997",
			#"data": {
				#"123": [
					#{
						#"action": logs.action,
						#"timestamp": logs.timestamp
					#}
				#]
			#}
		#})
		#requests.request(url, headers, HTTPClient.METHOD_POST, request_body)
		#requests.request_completed.connect(func(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray):
			#var json = JSON.new()
			#json.parse(body.get_string_from_utf8())
			#var response = json.get_data()
			#print(response)
			#remove_child(requests)
		#)
		#return requests.request_completed
	#return

func send_result(text: String):
	if multiplayer.is_server():
		var requests = HTTPRequest.new()
		add_child(requests)
		var headers = ["Content-Type: application/json"]
		requests.request(url_send, headers, HTTPClient.METHOD_POST, text)
		requests.request_completed.connect(func(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray):
			var json = JSON.new()
			json.parse(body.get_string_from_utf8())
			var response = json.get_data()
			print(response)
			remove_child(requests)
		)
		return requests.request_completed
	return
	
func send_player(text: String):
	if multiplayer.is_server():
		var requests = HTTPRequest.new()
		add_child(requests)
		var headers = ["Content-Type: application/json"]
		requests.request(url_player + Global.session_code + "/", headers, HTTPClient.METHOD_POST, text)
		requests.request_completed.connect(func(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray):
			var json = JSON.new()
			json.parse(body.get_string_from_utf8())
			var response = json.get_data()
			print(response)
			remove_child(requests)
		)
		return requests.request_completed
	return
	
func get_session():
	var requests = HTTPRequest.new()
	add_child(requests)
	var headers = ["Content-Type: application/json"]
	print(url_session + Global.session_code + "/")
	requests.request(url_session + Global.session_code + "/", headers, HTTPClient.METHOD_GET)
	requests.request_completed.connect(func(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray):
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response = json.get_data()
		Global.duration = (response["session"]["duration"])
		Global.max_players = (response["session"]["max_participantes"])
		remove_child(requests)
	)
	return requests.request_completed

@rpc("any_peer", "call_remote")
func set_session_stats(duration, max_players):
	Global.duration = duration
	Global.max_players = max_players

#func send_log_list(logs: Array):
	#if multiplayer.is_server():
		#var requests = HTTPRequest.new()
		#add_child(requests)
		#var request_body = []
		#var headers = ["Content-Type: application/json"]
		#for log_json in logs:
			##var content = ({
				##"player_id": log_json.player_id,
				##"action": log_json.action,
				##"timestamp": log_json.timestamp
			##})
			#var content = {
				#log_json.player_id : {
					#"action": log_json.action,
					#"timestamp": log_json.timestamp
				#}
			#}
			#request_body.append(content)
		#
		#requests.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(request_body))
		#requests.request_completed.connect(func(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray):
			#var json = JSON.new()
			#json.parse(body.get_string_from_utf8())
			#var response = json.get_data()
			#print(response)
			#remove_child(requests)
		#)
		#return requests.request_completed
	#return
	
