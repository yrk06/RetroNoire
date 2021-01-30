extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func take_player_movement():
	get_node('/root/MainTree/Player').has_movement = false
	
func give_player_movement():
	get_node('/root/MainTree/Player').has_movement = true

func take_player_control():
	get_node('/root/MainTree/Player').has_control = false
	
func give_player_control():
	get_node('/root/MainTree/Player').has_control = true
