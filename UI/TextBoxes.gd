extends Control


signal text_finished
signal option_selected(option)
signal dialog_finished
signal input_event
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_dialog
var currentPhraseIndex
var currentLetterIndex

var options = []

var cursor = 0 setget set_cursor

var input_enabled = false
var selection_enabled = false

var current_node_info = {
	"node": null,
	"callback": null,
}

onready var optionMenu = $wOptions/MarginContainer/HBoxContainer/OptionsMenu

var text = "" setget set_text
# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	pass # Replace with function body.

func _physics_process(delta):
	if input_enabled:
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("ui_accept"):
			emit_signal("input_event")
	if selection_enabled:
		if Input.is_action_just_pressed("walk_down"):
			self.cursor += 1
		if Input.is_action_just_pressed("walk_up"):
			self.cursor -= 1
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("ui_accept"):
			reset()
			emit_signal("option_selected",cursor)
			reset_player_signals()
			
func reset():
	$wOptions.visible = false
	$Normal.visible = false
	for p in optionMenu.get_children():
		p.visible = false
	visible = false
	self.text = ""
	
	input_enabled = false
	selection_enabled = false
	
	PlayerInterface.give_player_control()
	if is_connected("text_finished",self,"phrase_finished_op"):
		disconnect("text_finished",self,"phrase_finished_op")
	if is_connected("text_finished",self,"phrase_finished"):
		disconnect("text_finished",self,"phrase_finished")
	if is_connected("input_event",self,"reset"):
		disconnect("input_event",self,"reset")
	if is_connected("input_event",self,"reset_player_signals"):
		disconnect("input_event",self,"reset_player_signals")
	
func reset_player_signals():
	if current_node_info['node'] != null:
		disconnect("option_selected",current_node_info['node'],current_node_info['callback'])
	current_node_info['node'] = null
	current_node_info['callback'] = null

func wOptions(dialog,option,node,callback):
	$wOptions.visible = true
	options = option
	current_dialog = dialog
	currentPhraseIndex = 0
	currentLetterIndex = 0
	cursor = 0
	connect("option_selected",node,callback)
	current_node_info['node'] = node
	current_node_info['callback'] = callback
	connect("text_finished",self,"phrase_finished_op")
	$Timer.start()
	speech()

func classic(dialog):
	$Normal.visible = true
	current_dialog = dialog
	currentPhraseIndex = 0
	currentLetterIndex = 0
	connect("text_finished",self,"phrase_finished")
	$Timer.start()
	speech()

func phrase_finished_op():
	if currentPhraseIndex < len(current_dialog)-1:
		currentPhraseIndex += 1
		currentLetterIndex = 0
		input_enabled = true
		connect("input_event",self,'phrase_finished_handler')
		
	else:
		enable_options()

func enable_options():
	var nodes = optionMenu.get_children()
	for p in range(len(options)):
		nodes[p].visible = true
		nodes[p].text = options[p]
		nodes[p].unselect()
		if p == 0:
			nodes[p].select()
		selection_enabled = true

func set_cursor(value):
	var nodes = optionMenu.get_children()
	nodes[cursor].unselect()
	cursor = value
	var total_size = len(options)
	if cursor < 0:
		cursor += total_size
	if cursor >= total_size:
		cursor -= total_size
	nodes[cursor].select()

func disable_inputs():
	input_enabled = false

func phrase_finished():
	if currentPhraseIndex < len(current_dialog)-1:
		currentPhraseIndex += 1
		currentLetterIndex = 0
		input_enabled = true
		connect("input_event",self,'phrase_finished_handler')
		
	else:
		input_enabled = true
		connect("input_event",self,'reset_player_signals')
		connect("input_event",self,'reset')

func phrase_finished_handler():
	disconnect("input_event",self,"phrase_finished_handler")
	set_text('')
	disable_inputs()
	$Timer.start()
	speech()
	

func _add_letter():
	if currentLetterIndex >= len(current_dialog[currentPhraseIndex]):
		## Finished current text
		emit_signal("text_finished")
		$Timer.stop()
		return
	self.text += current_dialog[currentPhraseIndex][currentLetterIndex]
	currentLetterIndex +=1
	
func set_text(value):
	$wOptions/MarginContainer/HBoxContainer/Text.text = value
	$Normal/MarginContainer/Label.text = value
	text = value

func speech():
	var speech_event = Fmod.create_event_instance("event:/fx_npc_loop")
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	Fmod.set_event_timeline_position(speech_event,rng.randi_range(0,20)*1000)
	Fmod.start_event(speech_event)
	Fmod.set_event_volume(speech_event,1.5)
	yield(get_tree().create_timer(1),"timeout")
	Fmod.stop_event(speech_event,Fmod.FMOD_STUDIO_STOP_ALLOWFADEOUT)
	Fmod.release_event(speech_event)
