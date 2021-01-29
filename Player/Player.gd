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

var pistas_encontradas = []

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
	var portas = $DoorArea.get_overlapping_bodies()
	if len(portas) > 0:
		Game.enter_door(portas[0])
	
	var pistas = $InteractArea.get_overlapping_areas()
	if len(pistas) > 0:
		if not pistas[0].get_parent().state['investigada']:
			Fmod.set_global_parameter_by_name('mx_pista',1)
			pistas_encontradas.append(pistas[0].get_parent().backend_pista_reference)
		pistas[0].get_parent().interact()
		return
		
	var pessoas = $InteractArea.get_overlapping_bodies()
	if len(pessoas) > 0:
		pessoas[0].interact()
		return
		
		
		
		
		


func _on_InteractArea_area_entered(area):
	## Tem uma pista perto
	if area.get_parent().state['investigada']:
		Fmod.set_global_parameter_by_name('mx_pista',1)
	else:
		Fmod.set_global_parameter_by_name('mx_pista',2)
	pass


func _on_InteractArea_area_exited(area):
	var remaining = $InteractArea.get_overlapping_areas()
	if len(remaining) -1 == 0:
		Fmod.set_global_parameter_by_name('mx_pista',0)



func _on_DoorArea_body_entered(body):
	print(body.name)
