extends Node

var url = "http://localhost:3000/api/data"

func send_log(logs: Log):
	if multiplayer.is_server():
		var requests = HTTPRequest.new()
		add_child(requests)
		var headers = ["Content-Type: application/json"]
		var request_body = JSON.stringify({
			"player_id": logs.player_id,
			"action": logs.action,
			"timestamp": logs.timestamp
		})
		requests.request(url, headers, HTTPClient.METHOD_POST, request_body)
		requests.request_completed.connect(func(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray):
			var json = JSON.new()
			json.parse(body.get_string_from_utf8())
			var response = json.get_data()
			print(response)
			remove_child(requests)
		)
		return requests.request_completed
	return
	
func send_log_list(logs: Array):
	if multiplayer.is_server():
		var requests = HTTPRequest.new()
		add_child(requests)
		var request_body = []
		var headers = ["Content-Type: application/json"]
		for log_json in logs:
			var content = ({
				"player_id": log_json.player_id,
				"action": log_json.action,
				"timestamp": log_json.timestamp
			})
			request_body.append(content)
		
		requests.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(request_body))
		requests.request_completed.connect(func(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray):
			var json = JSON.new()
			json.parse(body.get_string_from_utf8())
			var response = json.get_data()
			print(response)
			remove_child(requests)
		)
		return requests.request_completed
	return
	
