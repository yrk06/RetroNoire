extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (bool) var to_interior
export (String) var interior_node_name
export (Vector2) var local_position_entry

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
