tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (String) var text setget set_text

var delta
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_text(txt):
	delta = -$Label.rect_size.y
	$Label.text = txt
	text = txt
	if txt == "":
		$Label.rect_size.y = 8
		
	


func _on_Label_resized():
	if not $Label:
		delta += $Label.rect_size.y
		$ColorRect.rect_size.y += delta
		rect_position -= Vector2(0,delta)
	
