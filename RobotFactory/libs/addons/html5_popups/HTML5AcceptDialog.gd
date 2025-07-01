@icon("icons/AcceptDialog.svg")
extends Node
class_name HTML5AcceptDialog
## Simple popup which displays some text and has a single "ok" button to dismiss it

## Text displayed by the dialog
@export_multiline var dialog_text:String = ""

## Triggered after the dialog is dismissed
signal done()

## Display popup. Note: this will freeze the project until the popup is dismissed!
func show():
	HTML5Popups.accept_dialog(dialog_text)
