extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func display_text(text,holdtime = 1,speed = 1):
	$Label.text = text
	$AnimationPlayer.play("fadein",-1,speed)
	yield(get_tree().create_timer((1/speed)+holdtime),'timeout')
	$AnimationPlayer.play("fadeout",-1,speed)
