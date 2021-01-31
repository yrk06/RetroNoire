extends Control

signal fade_finished
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func fadein():
	if $AnimationPlayer.is_playing():
		yield($AnimationPlayer,"animation_finished")
	$AnimationPlayer.play("fadein")
	
func fadeout():
	if $AnimationPlayer.is_playing():
		yield($AnimationPlayer,"animation_finished")
	$AnimationPlayer.play("fadeout")


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("fade_finished")
