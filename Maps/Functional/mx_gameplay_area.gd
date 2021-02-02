extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func load_data(dict):
	position = Vector2(dict['location']['x'],dict['location']['y'])
	$CollisionShape2D.shape.radius = dict['radius']


func _on_mx_gameplay_area_body_entered(body):
	Fmod.set_global_parameter_by_name("mx_area_investigacao",1)


func _on_mx_gameplay_area_body_exited(body):
	Fmod.set_global_parameter_by_name("mx_area_investigacao",0)
