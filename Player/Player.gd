extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Control
var has_control = true
var has_movement = true

## Movement Variables
var mov_direction = Vector2()
var last_mov = Vector2(0,1)
export var speed = 32

var pistas_encontradas = []

var fstep_event
# Called when the node enters the scene tree for the first time.
func _ready():
	fstep_event = Fmod.create_event_instance('event:/fx_pc_step')
	Fmod.set_event_volume(fstep_event,1)


func _physics_process(delta):
	process_input()
	process_movement(mov_direction)
	animation_handler()

func process_input():
	
	mov_direction = Vector2()
	if not has_control:
		return
	## Movement
	if has_movement:
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
		
	if Input.is_action_just_pressed("open_map"):
		UiInterface.open_map()
		
	if Input.is_action_just_pressed("quick_save"):
		Game.save_game()
		UiInterface.display_text("saved",0.5,2)
		
	if Input.is_action_just_pressed("quick_load"):
		Game.load_game()
		UiInterface.display_text("loaded",0.5,2)
	
	if mov_direction != Vector2():
		last_mov = mov_direction
	
func process_movement(direction):
	move_and_slide(direction * speed)
	
func interact():
	var portas = $DoorArea.get_overlapping_bodies()
	if len(portas) > 0:
		Game.enter_door(portas[0])
	
	var pistas = $InteractArea.get_overlapping_areas()
	if len(pistas) > 0:
		if not pistas[0].get_parent().state['investigada']:
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var value = rng.randi_range(0,2)
			Fmod.set_global_parameter_by_name("fx_pista_sound",value)
			var sound = Fmod.create_event_instance("event:/fx_pista_achada")
			Fmod.set_event_volume(sound,0.25)
			Fmod.start_event(sound)
			Fmod.release_event(sound)
			
			
			Fmod.set_global_parameter_by_name('mx_pista',1)
			pistas_encontradas.append(pistas[0].get_parent().persistent_reference)
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


func _on_InteractArea_area_exited(area):
	var remaining = $InteractArea.get_overlapping_areas()
	if len(remaining) -1 == 0:
		Fmod.set_global_parameter_by_name('mx_pista',0)

func animation_handler():
	##Animação ou idle?
	if mov_direction.length() == 0:
		##Idle
		$Timer.stop()
		if last_mov.y == 0:
			if last_mov.x > 0:
				ifnot_play('idle_right')
			elif last_mov.x < 0:
				ifnot_play('idle_left')
		else:
			if last_mov.y > 0:
				ifnot_play('idle_down')
			elif last_mov.y < 0:
				ifnot_play('idle_up')
		return
	if $Timer.is_stopped():
		$Timer.start()
	if mov_direction.y == 0:
		if mov_direction.x > 0:
			ifnot_play('walk_right')
		elif mov_direction.x < 0:
				ifnot_play('walk_left')
	else:
		if mov_direction.y > 0:
			ifnot_play('walk_down')
		elif mov_direction.y < 0:
			ifnot_play('walk_up')
	

func ifnot_play(anim):
	if $AnimatedSprite.animation != anim:
		$AnimatedSprite.play(anim)

func footsteps():
	Fmod.play_one_shot("event:/fx_pc_step",self)

#TODO
func _on_InteractArea_body_entered(body):
	Fmod.set_global_parameter_by_name('mx_danger',clamp(body.Type-1,0,2))
	pass


func _on_InteractArea_body_exited(body):
	var remaining = $InteractArea.get_overlapping_bodies()
	if len(remaining) -1 == 0:
		Fmod.set_global_parameter_by_name('mx_danger',0)
