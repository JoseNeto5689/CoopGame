extends Node2D

signal item_buyed(item: String, player_id: int, value: int)


func _on_buy_pendrive(body: Node2D) -> void:
	call_deferred("buy_item", "usb_stick", body.id, 5, )

func _on_buy_toolkit(body: Node2D) -> void:
	call_deferred("buy_item", "toolkit", body.id, 5)

func _on_buy_medkit(body: Node2D) -> void:
	call_deferred("buy_item", "medkit", body.id, 5)

func buy_item(item_name: String, player_id: int, value: int):
	item_buyed.emit(item_name, player_id, value)
