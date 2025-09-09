extends Node2D

signal item_buyed(item: String, player_id: int, value: int, hide_self: Callable)


func _on_buy_pendrive(body: Node2D) -> void:
	var hide_item: Callable = hide_item_func($Pendrive) 
	call_deferred("buy_item", "usb_stick", body.id, 5, hide_item)

func _on_buy_toolkit(body: Node2D) -> void:
	var hide_item: Callable = hide_item_func($ToolKit) 
	call_deferred("buy_item", "toolkit", body.id, 10, hide_item)

func _on_buy_medkit(body: Node2D) -> void:
	var hide_item: Callable = hide_item_func($MedKit) 
	call_deferred("buy_item", "medkit", body.id, 10, hide_item)
	
func _on_buy_gpu(body: Node2D) -> void:
	var hide_item: Callable = hide_item_func($Gpu) 
	call_deferred("buy_item", "gpu", body.id, 15, hide_item)

func _on_buy_ram(body: Node2D) -> void:
	var hide_item: Callable = hide_item_func($Ram) 
	call_deferred("buy_item", "ram", body.id, 15, hide_item)

func _on_buy_hd(body: Node2D) -> void:
	var hide_item: Callable = hide_item_func($HD) 
	call_deferred("buy_item", "hd", body.id, 15, hide_item)
	
func _on_buy_ssd(body: Node2D) -> void:
	var hide_item: Callable = hide_item_func($SSD) 
	call_deferred("buy_item", "ssd", body.id, 15, hide_item)
	
func _on_buy_cpu(body: Node2D) -> void:
	var hide_item: Callable = hide_item_func($CPU) 
	call_deferred("buy_item", "cpu", body.id, 15, hide_item)
	
func _on_buy_coffe(body: Node2D) -> void:
	var hide_item: Callable = hide_item_func($Coffe) 
	call_deferred("buy_item", "coffe", body.id, 30, hide_item)
	
func _on_buy_wifi(body: Node2D) -> void:
	var hide_item: Callable = hide_item_func($Wifi) 
	call_deferred("buy_item", "wifi", body.id, 40, hide_item)
	
func hide_item_func(body):
	return func():
		body.hide()
		await get_tree().create_timer(1).timeout
		body.show()

func buy_item(item_name: String, player_id: int, value: int, hide_self: Callable):
	item_buyed.emit(item_name, player_id, value, hide_self)
