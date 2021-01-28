tool
extends Node


## If the Relay will respond when triggered
export var enabled = true

## These are the signals that Trigger the relay
export (Array,Array) var signals setget set_signals

##These are the functions for the relay to call when triggered
export (Array,Array) var triggers setget set_triggers

##If you only want to trigger it once
export var once = false

##If you need to use Global Paths, set them here
export var reserved_words = {
	'player': '/root/Game/Player',
	'txtbox': '/root/Game/CanvasLayer/TextBox',
	'self': '.',
}

##If you would like to save the state of the Relay
export var save_state = false

## Set funtions to help while using in Editor
func set_triggers(value):
	if len(value) > len(triggers) and value[len(value)-1] == []:
		for p in range(len(value)-len(triggers)):
			triggers.append([NodePath(),'Function Name'])
	else:
		triggers = value

func set_signals(value):
	if len(value) > len(signals) and value[len(value)-1] == []:
		for p in range(len(value)-len(signals)):
			signals.append([NodePath(),'Signal Name'])
	else:
		signals = value

## The ready funtion is used to connect all signals
func _ready():
	for sp in signals:
		var tnode
		if not reserved_words.has(sp[0]):
			tnode = get_node(sp[0])
		else:
			tnode = get_node(reserved_words[sp[0]])
		if not tnode:
			print('Node Not Found: ',sp[0] )
			continue
		tnode.connect(sp[1],self,'trigger')
	if not Engine.is_editor_hint():
		var pl_triggers = triggers
		triggers = []
		adjust_trigger_self(pl_triggers)
	pass # Replace with function body.

## This function goes through all Triggers and call all functions
func trigger():
	#print('trigger')
	if not enabled:
		return
	if once:
		enabled = false
	for p in triggers:
		var target = get_node(p[0])
		if not target:
			print('target node ',p[0],' not found')
			continue
		if not target.has_method(p[1]):
			print('Method ' + p[1] + ' not found')
			continue
		if p[2] == []:
			#print('calling w/o args')
			target.call(p[1])
		else:
			#print('calling')
			target.callv(p[1],p[2])

## Paths are all relative, we need to adjust them (in case you use
## another higher level node, i.e a Area trigger)
## Also here we change reserved words to their global path
func adjust_trigger(tta):
	triggers = []
	for t in tta:
		var idv_t = []
		if not reserved_words.has(t[0]):
			idv_t.append('../'+t[0])
		else:
			idv_t.append(reserved_words[t[0]])
		idv_t.append(t[1])
		var args = []
		for a in range(2,len(t)):
			var arg
			arg = t[a]
			if t[a] is NodePath:
				arg = '../' + t[a]
			args.append(arg)
		idv_t.append(args)
		triggers.append(idv_t)


## this is basically the same function as above, but it only replaces
## Reserved words
func adjust_trigger_self(tta):
	triggers = []
	for t in tta:
		var idv_t = []
		if reserved_words.has(t[0]):
			idv_t.append(reserved_words[t[0]])
		else:
			idv_t.append(t[0])
		idv_t.append(t[1])
		var args = []
		for a in range(2,len(t)):
			var arg
			arg = t[a]
			args.append(arg)
		idv_t.append(args)
		triggers.append(idv_t)

##Set Enable
func set_enabled(value):
	enabled = value

## If you are using your own save functions, feel free to modify these ones
## Below
func save():
	if not save_state:
		return null
	return {'enabled':enabled}
	
func _load(data):
	if data:
		enabled = data['enabled']
