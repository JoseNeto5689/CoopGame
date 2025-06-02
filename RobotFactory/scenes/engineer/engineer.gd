extends Node2D

@export var gpu_img : CompressedTexture2D
@export var hd_img : CompressedTexture2D
@export var ram_img : CompressedTexture2D
@export var ssd_img : CompressedTexture2D
@export var cpu_img : CompressedTexture2D

signal player_start_interact(player_id: int, item: String)
signal player_stop_interact(player_id: int, item: String)


var item_needed := "cpu"

func change_item_needed(item_name = ""):
	if not item_name in ["gpu", "hd", "ram", "ssd", "cpu"]:
		item_name = ""
		$Sprite2D.texture = null
	match item_name:
		"gpu":
			$Sprite2D.texture = gpu_img
		"hd":
			$Sprite2D.texture = gpu_img
		"ram":
			$Sprite2D.texture = gpu_img
		"ssd":
			$Sprite2D.texture = gpu_img
		"cpu":
			$Sprite2D.texture = gpu_img
	item_needed = item_name




func _on_area_2d_body_entered(body: Node2D) -> void:
	player_start_interact.emit(body.id, item_needed)


func _on_area_2d_body_exited(body: Node2D) -> void:
	player_stop_interact.emit(body.id, item_needed)
