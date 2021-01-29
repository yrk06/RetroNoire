extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Control
var has_control = true
var has_movement = true

## Movement Variables
var mov_direction = Vector2()
export var speed = 32

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	process_input()
	process_movement(mov_direction)

func process_input():
	if not has_control:
		return
	## Movement
	if has_movement:
		mov_direction = Vector2()
		if Input.is_action_pressed("walk_up"):
			mov_direction.y -= 1
		if Input.is_action_pressed("walk_down"):
			mov_direction.y += 1
		if Input.is_action_pressed("walk_left"):
			mov_direction.x -= 1
		if Input.is_action_pressed("walk_right"):
			mov_direction.x += 1
		mov_direction = mov_direction.normalized()
	## Other Actions
	if Input.is_action_just_pressed("interact"):
		interact()
	
func process_movement(direction):
	move_and_slide(direction * speed)
	
func interact():
	var pistas = $InteractArea.get_overlapping_areas()
	if len(pistas) > 0:
		pistas[0].get_parent().interact()
		return
		
	var pessoas = $InteractArea.get_overlapping_bodies()
	if len(pessoas) > 0:
		pessoas[0].interact()
		return
		
		
		
		
		
