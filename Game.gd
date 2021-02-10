extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var case_NPCs = []
var case_Pistas = []

var case_logic_relay = []
var case_mx_areas = []

var case_villain
var current_case_name = 'case_Frederico'

var npcObject = preload("res://Object/NPCsObject.gd")
var pistaObject = preload("res://Object/PistasObject.gd")

var mainWorld = preload("res://Maps/WorldMap.tscn")
var LogicRelay = preload("res://addons/LogicConectors/LogicRelay.gd")

var mx_gameplay
var mx_menu
var bg_noite
# Called when the node enters the scene tree for the first time.
func _ready():
	#load_case_file(current_case_name)
	##Sound Listener
	
	var listener = Node2D.new()
	add_child(listener)
	Fmod.set_software_format(0, Fmod.FMOD_SPEAKERMODE_STEREO, 0)
	Fmod.init(1024, Fmod.FMOD_STUDIO_INIT_LIVEUPDATE, Fmod.FMOD_INIT_NORMAL)
	
	# load banks
	Fmod.load_bank("res://Sound/Master.strings.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	Fmod.load_bank("res://Sound/Master.bank", Fmod.FMOD_STUDIO_LOAD_BANK_NORMAL)
	
	##Fmod.add_listener(0, $Node2D)
	
	## Tocar os eventos
	mx_gameplay = Fmod.create_event_instance("event:/mx_gameplay_dynamic")
	mx_menu = Fmod.create_event_instance("event:/mx_menu_dynamic")
	Fmod.set_global_parameter_by_name("mx_creditos",0)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var value = rng.randf_range(0,1)
	Fmod.set_global_parameter_by_name("mx_tension",value)
	Fmod.start_event(mx_menu)
	Fmod.set_event_volume(mx_menu,0.4)
	
	bg_noite = Fmod.create_event_instance("event:/bg_noite") 

func enter_door(door):
	## we need to load interior?
	yield(UiInterface.fadein(),'fade_finished')
	var to_interior = door.to_interior
	var was_interior = false
	if to_interior:
		var interior_name = door.interior_node_name.replace(" ",'')
		## is it already loaded?
		var is_loaded = get_node_or_null('/root/MainTree/Interior/'+door.interior_node_name)
		if not is_loaded:
			
			##Unload any possible interiors
			for c in get_node('/root/MainTree/Interior').get_children():
				was_interior = true
				c.queue_free()
				yield(c,"tree_exited")
			## Load Interior at pos (0,0)
			var interior = load("res://Maps/Interior/"+door.interior_node_name+".tscn").instance()
			get_node('/root/MainTree/Interior').add_child(interior)
		##Unload map
		for c in get_node('/root/MainTree/WorldMapNode').get_children():
			c.queue_free()
			yield(c,"tree_exited")
		if not was_interior:
			PlayerInterface.is_inside = true
			PlayerInterface.last_outside_position = PlayerInterface.get_player().position
	else:
		## Check is world map is loaded
		##Unload any possible interiors
		for c in get_node('/root/MainTree/Interior').get_children():
			was_interior = true
			c.queue_free()
			yield(c,"tree_exited")
		
		##Load World
		if not len(get_node('/root/MainTree/WorldMapNode').get_children()) > 0:
			var exterior = mainWorld.instance()
			get_node('/root/MainTree/WorldMapNode').add_child(exterior)
		PlayerInterface.is_inside = false
	##Position Player
	get_node('/root/MainTree/Player').global_position = door.local_position_entry
	try_loading_all_instances()
	UiInterface.fadeout()
	
func try_loading_all_instances():
	try_loading_npcs()
	try_loading_pistas()
	try_load_logic_relay()
	try_load_mx_area()
	
	
func try_loading_npcs():
	for p in case_NPCs:
		instantiate_npc(p)
		
func try_loading_pistas():
	for p in case_Pistas:
		instantiate_pista(p)

func load_case_file(case_name):
	current_case_name = case_name
	var jsonString
	var file = File.new()
	file.open('res://case_files/'+case_name+'.json',File.READ)
	jsonString = file.get_as_text()
	file.close()
	
	for c in get_node('/root/MainTree/WorldMapNode').get_children():
		c.queue_free()
		yield(c,'tree_exited')
		
	for c in get_node('/root/MainTree/Interior').get_children():
		c.queue_free()
		yield(c,'tree_exited')
	
	var content = JSON.parse(jsonString).result
	
	case_NPCs = []
	case_Pistas = []
	case_logic_relay = []
	case_mx_areas = []
	
	var mapname = content['start_info']["map"]
	if mapname == "WorldMap":
		var holder = get_node('/root/MainTree/WorldMapNode')
		holder.add_child(mainWorld.instance())
	else:
		var holder = get_node('/root/MainTree/Interior')
		var interior = load("res://Maps/Interior/"+mapname+".tscn").instance()
		holder.add_child(interior)
	
	
	var npcs = content["NPCs"]
	for p in npcs:
		instantiate_npc(load_npc(p))
	var pistas = content["Pistas"]
	for p in pistas:
		instantiate_pista(load_pista(p))
	UiInterface.display_text(content['case_name'],5,1)
	var poi = content["POI"]
	UiInterface.load_map(poi)
	var lr = content["LogicRelay"]
	for p in lr:
		case_logic_relay.append(p)
		load_logic_relay(p)
	var mx_areas = content['mx_areas']
	for p in mx_areas:
		case_mx_areas.append(p)
		load_mx_gameplay_area(p)
	case_villain = content["villain"]
	get_node("/root/MainTree").add_child(preload("res://Player/Player.tscn").instance())
	get_node("/root/MainTree/Player").position = Vector2(content['start_info']['x'],content['start_info']['y'])

func load_non_persisten_data_case_file(case_name):
	var jsonString
	var file = File.new()
	file.open('res://case_files/'+case_name+'.json',File.READ)
	jsonString = file.get_as_text()
	file.close()
	
	var content = JSON.parse(jsonString).result
	
	var mx_areas = content['mx_areas']
	for p in mx_areas:
		case_mx_areas.append(p)
		load_mx_gameplay_area(p)
	case_villain = content["villain"]
	
func try_load_mx_area():
	for p in case_mx_areas:
		load_mx_gameplay_area(p)
	
func load_mx_gameplay_area(dict):
	var path = dict["location"]['location']
	var target = get_map_node(path)
	
	## Não existe a cena agora
	if not target:
		return
	## Esse nó ja existe?
	if target.get_node_or_null(dict["name"]):
		return
	var instance = preload("res://Maps/Functional/mx_gameplay_area.tscn").instance()
	instance.load_data(dict)
	target.add_child(instance)

func try_load_logic_relay():
	for p in case_logic_relay:
		load_logic_relay(p)

func load_logic_relay(dict):
	var path = dict["location"]
	var target = get_map_node(path)
	
	## Não existe a cena agora
	if not target:
		return
	## Esse nó ja existe?
	if target.get_node_or_null(dict["name"]):
		return
	var instance = Node.new()
	instance.set_script(LogicRelay)
	instance.signals = dict["signals"]
	instance.triggers = dict["triggers"]
	instance.once = dict["once"]
	instance.enabled = dict["enabled"]
	instance.name = dict["name"]
	target.add_child(instance)
	
func delete_logic_relay(reference):
	if reference in case_logic_relay:
		case_logic_relay.erase(reference)

func load_npc(data):
	var npc = npcObject.new()
	npc.set_data(data)
	case_NPCs.append(npc)
	return npc

func instantiate_npc(npc):
	var where = get_map_node(npc.location["path"])
	if where:
		var instance = npc.createNPCInstansce()
		if instance:
			where.add_child(instance)

func load_pista(data):
	var pista = pistaObject.new()
	pista.set_data(data)
	case_Pistas.append(pista)
	return pista

func instantiate_pista(pista):
	var where = get_map_node(pista.location["path"])
	if where:
		var instance = pista.createPistaInstansce()
		if instance:
			where.add_child(instance)

func save_game():
	##Pegar todas as infos persistentes e salvar
	var currentMap = get_node('/root/MainTree/WorldMapNode/WorldMap')
	if not currentMap:
		##Salvar o interior atual
		currentMap = get_node('/root/MainTree/Interior').get_child(0)
		
	var save_data = {}
	var playerPos = get_node('/root/MainTree/Player').global_position
	save_data['location'] = {}
	save_data['location']["map"] = currentMap.name
	save_data['location']["x"] = currentMap.global_transform.xform_inv(playerPos).x
	save_data['location']["y"] = currentMap.global_transform.xform_inv(playerPos).y
	save_data["NPC"] = []
	save_data["case_name"] = current_case_name
	for p in case_NPCs:
		save_data["NPC"].append(p.save_data())
		
	save_data["Pistas"] = []
	for p in case_Pistas:
		save_data["Pistas"].append(p.save_data())
	
	save_data["LogicRelay"] = []
	for p in case_logic_relay:
		save_data["LogicRelay"].append(p)
	save_data["map_poi"] = UiInterface.save_map()
	
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(save_data))
	save_game.close()
	
func load_game():
	Fmod.stop_event(mx_menu,Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
	Fmod.start_event(bg_noite)
	Fmod.start_event(mx_gameplay)
	var save_game = File.new()
	save_game.open("user://savegame.save", File.READ)
	var jsonSave = save_game.get_as_text()
	if not jsonSave:
		return
	save_game.close()
	var saved_dict = JSON.parse(jsonSave).result
	
	current_case_name = saved_dict["case_name"]
	
	yield(UiInterface.fadein(),'fade_finished')
	
	for c in get_node('/root/MainTree/WorldMapNode').get_children():
		c.queue_free()
		yield(c,'tree_exited')
		
	var player = get_node('/root/MainTree/Player')
	if player:
		player.queue_free()
		yield(player,"tree_exited")

		
	for c in get_node('/root/MainTree/Interior').get_children():
		c.queue_free()
		yield(c,'tree_exited')
	
	case_NPCs = []
	case_Pistas = []
	case_logic_relay = []
	case_mx_areas = []
	
	get_node("/root/MainTree").add_child(preload("res://Player/Player.tscn").instance())
	
	
	##Load Location
	var mapname = saved_dict['location']["map"]
	if mapname == "WorldMap":
		var holder = get_node('/root/MainTree/WorldMapNode')
		holder.add_child(mainWorld.instance())
	else:
		var holder = get_node('/root/MainTree/Interior')
		var interior = load("res://Maps/Interior/"+mapname+".tscn").instance()
		holder.add_child(interior)

	get_node('/root/MainTree/Player').global_position = Vector2(saved_dict['location']["x"],saved_dict['location']["y"])
	
	var npcs = saved_dict["NPC"]
	for p in npcs:
		instantiate_npc(load_npc(p))
		
	var pistas = saved_dict["Pistas"]
	for p in pistas:
		instantiate_pista(load_pista(p))
	
	var lr = saved_dict["LogicRelay"]
	for p in lr:
		case_logic_relay.append(p)
		load_logic_relay(p)
	
	UiInterface.load_map(saved_dict["map_poi"])
	
	load_non_persisten_data_case_file(current_case_name)
	UiInterface.close_menu()
	UiInterface.fadeout()
	
func get_files_in_folder(folder_path: String) -> Array:
	
	var file_paths := []
	
	var dir := Directory.new()
	dir.open(folder_path)
	dir.list_dir_begin(true, true) # true, true params to skip hidden and navigational
	
	while true:
		var file := dir.get_next()
		if file == "":
			break
		file_paths.append(file)

	dir.list_dir_end()
	
	return file_paths

func quit():
	get_tree().quit()

func load_case_menu():
	UiInterface.close_menu()
	UiInterface.open_cases_menu()
	
func new_game(case):
	Fmod.stop_event(mx_menu,Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
	Fmod.start_event(bg_noite)
	Fmod.start_event(mx_gameplay)
	UiInterface.close_case_menu()
	load_case_file(case)

func arrest(npc):
	UiInterface.open_confirm_arrest(npc.name,self,'arrest_confirmed','arrest_denied')

func arrest_confirmed(node):
	node.disconnect('confirmed',self,'arrest_confirmed')
	node.disconnect('denied',self,'arrest_denied')
	var npc_name = node.npc
	var win = npc_name == case_villain
	var total_pista = len(case_Pistas)
	var achadas = 0
	for p in case_Pistas:
		if p["state"]["investigada"]:
			achadas += 1
	UiInterface.open_endGame(win,achadas,total_pista)

func arrest_denied(node):
	node.disconnect('confirmed',self,'arrest_confirmed')
	node.disconnect('denied',self,'arrest_denied')

static func node_exists(node):
	if node == null:
	  return false

	var ref = weakref(node).get_ref()

	if ref == null:
	  return false

	if ref.is_queued_for_deletion():
	  return false

	return true

func get_map_node(nodeName):
	if nodeName == "WorldMap":
		return get_node_or_null('/root/MainTree/WorldMapNode/WorldMap')
	else:
		return get_node_or_null('/root/MainTree/Interior/'+nodeName)
