extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (String) var text setget set_text

func set_text(value):
	$TxtBoxLabel.text = value
	text = value
	
func select():
	$SelectionSymbol.visible = true
	
func unselect():
	$SelectionSymbol.visible = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
