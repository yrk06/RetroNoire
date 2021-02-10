extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var victory

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if not visible:
		return
	if Input.is_action_just_pressed("ui_accept"):
		yield(get_tree().create_timer(0.1),"timeout")
		UiInterface.show_credits()
		visible = false
		Fmod.stop_event(Game.mx_gameplay,Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
		Fmod.stop_event(Game.bg_noite,Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
		Fmod.start_event(Game.mx_menu)
		Fmod.set_global_parameter_by_name("mx_creditos",1)
		Fmod.set_global_parameter_by_name("mx_tension",1 if victory else 0)

func set_info(result,pistas_achadas,pistas_total):
	victory = result
	$Result.text = tr("GAME_RESULT_WON") if result else tr("GAME_RESULT_LOST")
	$MarginContainer/VBoxContainer/HBoxContainer/Stat.text = str(pistas_achadas)+'/'+str(pistas_total)
