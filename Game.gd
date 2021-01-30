extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var case_NPCs = []
var case_Pistas = []

var npcObject = preload("res://Object/NPCsObject.gd")
var pistaObject = preload("res://Object/PistasObject.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	load_case_file('case_001')
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
	Fmod.set_event_volume(event,0.1)


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
		
		try_loading_npcs()
		try_loading_pistas()
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
	try_loading_npcs()
	
func try_loading_npcs():
	for p in case_NPCs:
		instantiate_npc(p)
		
func try_loading_pistas():
	for p in case_Pistas:
		instantiate_pista(p)

func load_case_file(case_name):
	var jsonString
	var file = File.new()
	file.open('res://case_files/'+case_name+'.json',File.READ)
	jsonString = file.get_as_text()
	file.close()
	
	var content = JSON.parse(jsonString).result
	print(content)
	var npcs = content["NPCs"]
	for p in npcs:
		instantiate_npc(load_npc(p))
	var pistas = content["Pistas"]
	for p in pistas:
		instantiate_pista(load_pista(p))

func load_npc(data):
	var npc = npcObject.new()
	npc.set_data(data)
	case_NPCs.append(npc)
	return npc

func instantiate_npc(npc):
	var where = get_node(npc.location["path"])
	if where:
		where.add_child(npc.createNPCInstansce())

func load_pista(data):
	var pista = pistaObject.new()
	pista.set_data(data)
	case_Pistas.append(pista)
	return pista

func instantiate_pista(pista):
	var where = get_node(pista.location["path"])
	if where:
		where.add_child(pista.createPistaInstansce())
