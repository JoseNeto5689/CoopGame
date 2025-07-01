extends RefCounted
class_name HTML5Popups

## A simple message popup, which the user can only dismiss
static func accept_dialog(text:String):
	var interface = JavaScriptBridge.get_interface('window')
	return interface.alert(text)

## Same as accept_dialog(), but this is the name in JS
static func alert(text:String):
	return accept_dialog(text)




## Prompts the user with a yes/no or confirm/cancel popup
static func confirmation_dialog(text:String)->bool:
	var interface = JavaScriptBridge.get_interface('window')
	return interface.confirm(text)

## Same as confirmation_dialog(), but this is the name in JS
static func confirm(text:String)->bool:
	return confirmation_dialog(text)



## Prompts the user to enter some text
static func input_dialog(text:String, default_value:String="")->String:
	var interface = JavaScriptBridge.get_interface('window')
	return interface.prompt(text, default_value)

## Same as input_dialog(), but this is the name in JS
static func prompt(text:String, default_value:String="")->String:
	return input_dialog(text, default_value)
