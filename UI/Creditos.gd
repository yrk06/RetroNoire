extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if not visible:
		return
	if Input.is_action_just_pressed("ui_accept"):
		visible = false
		get_tree().reload_current_scene()
		Fmod.set_global_parameter_by_name("mx_creditos",0)
		
