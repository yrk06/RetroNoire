extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Fmod.set_software_format(0, Fmod.FMOD_SPEAKERMODE_STEREO, 0)
	Fmod.init(1024, Fmod.FMOD_STUDIO_INIT_LIVEUPDATE, Fmod.FMOD_INIT_NORMAL)
	
	# load banks
	Fmod.load_bank("res://assets/testAssets/Master.strings.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	Fmod.load_bank("res://assets/testAssets/Master.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	
	## Descomentar essa linha faz o jogo não rodar (?)
	Fmod.add_listener(0, $Node2D)
	
	## Tocar os eventos
	var event = Fmod.create_event_instance("event:/mx_gameplay_dynamic")
	Fmod.start_event(event)
	Fmod.set_event_volume(event,0.3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
