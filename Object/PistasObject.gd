extends Reference


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var small_sprite
var big_sprite

var analise

var name

var state = {
	'investigada':false
}

var physical_reference = null

var location = {
	"path": '.',
	"location":Vector2()
}

var npcs_to_trigger = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_data(dict):
	#small_sprite = dict['small_sprite']
	#big_sprite = dict['big_sprite']
	analise = dict['analise']
	state = dict["state"]
	name = dict["name"]
	location = {
		"path": dict["location"]["path"],
		'location':Vector2(dict["location"]['x'],dict["location"]['y'])
	}
	npcs_to_trigger = dict["npcs"]

func update_state(ns):
	state = ns

func save_data():
	var dict = {}
	#dict['small_sprite'] = small_sprite
	#dict['big_sprite'] = big_sprite
	dict['analise'] = analise
	dict["state"] = state
	dict["name"] = name
	dict["location"] = {
		"path": location["path"],
		"x": location["location"].x,
		"y": location["location"].y,
	}
	dict["npcs"] = npcs_to_trigger
	return dict
	
func createPistaInstansce():
	var Pista = preload('res://investigacao/Pista.tscn').instance()
	#Pista.small_sprite = small_sprite
	#Pista.big_sprite = big_sprite
	Pista.analise = analise
	Pista.state = state
	Pista.name = name
	Pista.location = location["location"]
	Pista.persistent_reference = self
	physical_reference = Pista
	return Pista

func trigger():
	var allNpcs = Game.case_NPCs
	for npc in npcs_to_trigger:
		for p in allNpcs:
			if p.name == npc:
				p.unlock_options()
