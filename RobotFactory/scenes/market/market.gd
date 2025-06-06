extends Node2D

signal item_buyed(item: String, player_id: int, value: int)

func _on_buy_pendrive(body: Node2D) -> void:
	call_deferred("buy_item", "usb_stick", body.id, 5, )

func _on_buy_toolkit(body: Node2D) -> void:
	call_deferred("buy_item", "toolkit", body.id, 5)

func _on_buy_medkit(body: Node2D) -> void:
	call_deferred("buy_item", "medkit", body.id, 5)
	
func _on_buy_gpu(body: Node2D) -> void:
	call_deferred("buy_item", "gpu", body.id, 5, )

func _on_buy_ram(body: Node2D) -> void:
	call_deferred("buy_item", "ram", body.id, 5)

func _on_buy_hd(body: Node2D) -> void:
	call_deferred("buy_item", "hd", body.id, 5)
	
func _on_buy_ssd(body: Node2D) -> void:
	call_deferred("buy_item", "ssd", body.id, 5)
	
func _on_buy_cpu(body: Node2D) -> void:
	call_deferred("buy_item", "cpu", body.id, 5)
	
func _on_buy_coffe(body: Node2D) -> void:
	call_deferred("buy_item", "coffe", body.id, 5)
	
func _on_buy_wifi(body: Node2D) -> void:
	call_deferred("buy_item", "wifi", body.id, 5)

func buy_item(item_name: String, player_id: int, value: int):
	item_buyed.emit(item_name, player_id, value)
