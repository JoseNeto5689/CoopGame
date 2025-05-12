extends CanvasLayer

func _ready() -> void:
	update_pendrive()
	update_money()

func show_interact():
	$InteractHUD.show()

func hide_interact():
	$InteractHUD.hide()

func show_hud():
	$HUD.show()

func hide_hud():
	$HUD.hide()

func show_game_over():
	$GameOver.show()
	
func hide_game_over():
	$GameOver.hide()

@rpc("any_peer", "call_local")
func update_pendrive():
	$HUD/PendriveNumber.text = str(Global.usb_stick_number)

@rpc("any_peer", "call_local")
func update_money():
	$HUD/MoneyQuantity.text = str(Global.money)
