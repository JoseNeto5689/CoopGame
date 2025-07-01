@icon("icons/InputDialog.svg")
extends Node
class_name HTML5InputDialog
## A popup with a text input field, similar to a LineEdit. It also has the "yes/okay" and "no/cancel" buttons

## Text displayed by the dialog
@export_multiline var dialog_text:String = ""
## Pre-filled value in the input field
@export var default_value:String = ""

## "Cancel" was pressed or nothing was entered
signal canceled()
## "Ok" was pressed and something was entered
signal confirmed(text:String)

## Triggers after the dialog is dismissed. Useful in combination with `await`
signal done(result:String)
 
## Display popup. Note: this will freeze the project until the popup is dismissed!
func show()->String:
	var value:String = HTML5Popups.input_dialog(dialog_text, default_value)
	if value == "":
		canceled.emit()
	else:
		confirmed.emit(value)
	done.emit(value)
	return value
