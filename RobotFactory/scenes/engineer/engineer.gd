extends Node2D

@export var gpu_img : CompressedTexture2D
@export var hd_img : CompressedTexture2D
@export var ram_img : CompressedTexture2D
@export var ssd_img : CompressedTexture2D
@export var cpu_img : CompressedTexture2D

signal player_start_interact(player_id: int, item: String)
signal player_stop_interact(player_id: int, item: String)


var item_needed := ""

@rpc("any_peer", "call_local")
func change_item_needed(item_name := ""):
	if not item_name in ["gpu", "hd", "ram", "ssd", "cpu"]:
		item_needed = ""
		$Sprite2D.texture = null
		$Sprite2D.hide()
	match item_name:
		"gpu":
			$Sprite2D.texture = gpu_img
		"hd":
			$Sprite2D.texture = hd_img
		"ram":
			$Sprite2D.texture = ram_img
		"ssd":
			$Sprite2D.texture = ssd_img
		"cpu":
			$Sprite2D.texture = cpu_img
	item_needed = item_name
	$Sprite2D.show()

func _ready() -> void:
	change_item_needed()



func _on_area_2d_body_entered(body: Node2D) -> void:
	player_start_interact.emit(body.id, item_needed)


func _on_area_2d_body_exited(body: Node2D) -> void:
	player_stop_interact.emit(body.id, item_needed)
