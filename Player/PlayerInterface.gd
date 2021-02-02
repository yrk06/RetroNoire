extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = null

var is_inside = true
var last_outside_position = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func take_player_movement():
	get_player().has_movement = false
	
func give_player_movement():
	get_player().has_movement = true

func take_player_control():
	get_player().has_control = false
	
func give_player_control():
	get_player().has_control = true

func get_player():
	if not Game.node_exists(player):
		player = get_node('/root/MainTree/Player')
	return player

func get_pistas_encontradas():
	return get_player().pistas_encontradas

func get_player_outside_position():
	if is_inside:
		return last_outside_position
	else:
		return get_player().position
