@icon("icons/ConfirmationDialog.svg")
extends Node
class_name HTML5ConfirmationDialog
## A popup with "yes/okay" and "no/cancel" buttons (actual button text may vary between browsers)

## Text displayed by the dialog
@export_multiline var dialog_text:String = ""

## Triggers if "Cancel" or "No" is pressed
signal canceled()
## Triggers if "Confirm" or "Yes" is pressed
signal confirmed()

## Triggers after the dialog is dismissed. Useful in combination with `await`
signal done(result:bool)

## Display popup. Note: this will freeze the project until the popup is dismissed!
func show()->bool:
	var value:bool = HTML5Popups.confirmation_dialog(dialog_text)
	if value:
		confirmed.emit()
	else:
		canceled.emit()
	done.emit(value)
	return value
