# HTML5 Popups (for godot 4)
Godot 4 addon that adds javascript `alert()`, `confirm()`, and `prompt()` popups for web exports.

Note that displaying any of these popups will freeze the project until they are dismissed!  
Also keep in mind that the browser may give the option to disallow the page from showing more popups.  
*Also* also, this addon obviously only works on web exports.

## Usage through nodes

### HTML5AcceptDialog
Simple popup which displays some text and has a single "ok" button to dismiss it.

Properties:
- `dialog_text:String`: The text to display in the popup

Signals:
- `done()`: emitted when the popup is dismissed

Functions:
- `show()->null`: display the popup


### HTML5ConfirmationDialog
A popup with "yes/okay" and "no/cancel" buttons (actual button text may vary between browsers).

Properties:
- `dialog_text:String`: The text to display in the popup

Signals:
- `canceled()`: The popup was dismissed or the "no/cancel" button was pressed
- `confirmed()`: The "yes/okay" button was pressed
- `done(result:bool)`: Triggers both if the popup was canceled or confirmed, with `result` as `true` if it was confirmed, and `false` otherwise

Functions:
- `show()->bool`: display the popup (return value is the same as the `done()` signal)

### HTML5InputDialog
A popup with a text input field, similar to a LineEdit. It also has the "yes/okay" and "no/cancel" buttons.

Properties:
- `dialog_text:String`: The text to display in the popup
- `default_value:String`: A pre-filled value for in the input field

Signals:
- `canceled()`: The popup was dismissed or the user entered an empty string (`""`)
- `confirmed(text:String)`: The user entered some text & pressed "yes/okay"
- `done(result:String)`: Triggers both if the popup was canceled or confirmed, with `result` as the entered text if it was confirmed, and and empty string (`""`) otherwise

Functions:
- `show()->string`: display the popup (return value is the same as the `done()` signal)


## Usage through `HTML5Popups`
If you prefer not to use nodes, you can use the `HTML5Popups` static class to summon all the same popups as with the nodes.

Functions (static):
- `accept_dialog(text:String)->null`: Summon the HTML5AcceptDialog node popup
- `confirmation_dialog(text:String)->bool`: Summon the HTML5ConfirmationDialog node popup
- `input_dialog(text:String, default_value:String="")->String`: Summon the HTML5InputDialog node popup

You can also use the Javascript names instead:
- `alert(text:String)->null`: same as `accept_dialog`
- `confirm(text:String)->bool`: same as `confirmation_dialog`
- `prompt(text:String, default_value:String="")->String`: same as `input_dialog` 