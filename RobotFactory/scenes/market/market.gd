extends Node2D

signal item_buyed(item: String, player_id: int)

func _on_buy_pendrive(body: Node2D) -> void:
	item_buyed.emit("usb_stick", body.id)


func _on_buy_toolkit(body: Node2D) -> void:
	item_buyed.emit("toolkit", body.id)
