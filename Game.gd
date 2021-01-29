extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	##Sound Listener
	
	var listener = Node2D.new()
	add_child(listener)
	Fmod.set_software_format(0, Fmod.FMOD_SPEAKERMODE_STEREO, 0)
	Fmod.init(1024, Fmod.FMOD_STUDIO_INIT_LIVEUPDATE, Fmod.FMOD_INIT_NORMAL)
	
	# load banks
	Fmod.load_bank("res://assets/testAssets/Master.strings.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	Fmod.load_bank("res://assets/testAssets/Master.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	
	Fmod.add_listener(0, $Node2D)
	
	## Tocar os eventos
	var event = Fmod.create_event_instance("event:/mx_gameplay_dynamic")
	Fmod.start_event(event)
	Fmod.set_event_volume(event,0.3)


func enter_door(door):
	## we need to load interior?
	var to_interior = door.to_interior
	
	if to_interior:
		var interior_name = door.interior_node_name.replace(" ",'')
		## is it already loaded?
		var is_loaded = get_node('/root/MainTree/Interior/'+door.interior_node_name)
		if not is_loaded:
			
			##Unload any possible interiors
			for c in get_node('/root/MainTree/Interior').get_children():
				c.queue_free()
			## Load Interior at pos (0,0)
			var interior = load("res://Maps/Interior/"+door.interior_node_name+".tscn").instance()
			get_node('/root/MainTree/Interior').add_child(interior)
		
		##Unload map
		for c in get_node('/root/MainTree/WorldMapNode').get_children():
			c.queue_free()
		
		##Position Player
		get_node('/root/MainTree/Player').global_position = door.local_position_entry
		return
	## Check is world map is loaded
	##Unload any possible interiors
	for c in get_node('/root/MainTree/Interior').get_children():
		c.queue_free()
	
	##Load World
	if not len(get_node('/root/MainTree/WorldMapNode').get_children()) > 0:
		var exterior = preload("res://Maps/WorldMap.tscn").instance()
		get_node('/root/MainTree/WorldMapNode').add_child(exterior)
	##Position Player
	get_node('/root/MainTree/Player').global_position = door.local_position_entry
	pass
