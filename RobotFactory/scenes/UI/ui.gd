extends CanvasLayer

func _ready() -> void:
	update_pendrive()

func show_interact():
	$Container.show()

func hide_interact():
	$Container.hide()

func show_hud():
	$HUD.show()

func hide_hud():
	$HUD.hide()

@rpc("any_peer", "call_local")
func update_pendrive():
	$HUD/PendriveNumber.text = str(Global.usb_sticker_number)
