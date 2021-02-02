extends Reference


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum NPC_Types {
	IRRELEVANTE,
	BOM,
	NEUTRO,
	MAU,
}
export (NPC_Types) var Type
export var dialogs ={
	"dialogo Inicial":[],
	"concordar":[],
	"later":[],
	"doubt":[],
	"lie":[],
	"recusa":[],
	"verdade":[],
}

var options = ["Até mais", "Concordar"]

var state = {
	'angry':false,
	'defeated':false,
}

var physical_reference = null

var location = {
	"path": '.',
	"location":Vector2()
}

var name

var spriteFrames
var spriteVariation

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_data(dict):
	Type = dict['Type']
	dialogs = dict['dialogs']
	options = dict['options']
	state = dict["state"]
	name = dict["name"]
	spriteFrames = dict["spriteFrames"]
	spriteVariation = dict["variation"]
	location = {
		"path": dict["location"]["path"],
		'location':Vector2(dict["location"]['x'],dict["location"]['y'])
		}
	pass

func unlock_options():
	options = 4
	if physical_reference:
		physical_reference.options = options

func update_state(ns):
	state = ns

func save_data():
	var dict = {}
	dict['Type'] = Type
	dict['dialogs'] = dialogs
	dict['options'] = options
	dict["state"] = state
	dict["name"] = name
	dict["spriteFrames"] = spriteFrames
	dict["variation"] = spriteVariation
	dict["location"] = {
		"path": location["path"],
		"x": location["location"].x,
		"y": location["location"].y,
	}
	return dict
	
func createNPCInstansce():
	print('instancing npc')
	if Game.node_exists(physical_reference):
		print('npc ' + name + ' already exists')
		return
	var NPC = preload('res://NPCs/NPC.tscn').instance()
	NPC.Type = Type
	NPC.dialogs = dialogs
	NPC.options = options
	NPC.state = state
	NPC.name = name
	NPC.persistent_reference = self
	NPC.location = location['location']
	var sprite = load('res://assets/art/Sprites/'+('Male_NPCs.tres' if spriteFrames == 1 else 'Female_NPCs.tres'))
	NPC.set_frames(sprite,spriteVariation)
	physical_reference = NPC
	return NPC
