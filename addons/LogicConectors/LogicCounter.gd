tool
extends Node

signal lower_limit ##Triggered when the counter reaches the lower_limit
signal upper_limit ##Triggered when the counter reaches the upper_limit

##Which signals increase or decrease the counter
export (Array,Array) var signalsToIncrement setget set_signalsToIncrement
export (Array,Array) var signalsToDecrement setget set_signalsToDecrement


## Signal Group works by picking the base name + the number until the size
## For instance: enemy0, enemy1, ..., enemyN 
## would all be connected with the same signal
export (Array,Array) var signalGroupIncrement setget set_signalGroupIncrement
export (Array,Array) var signalGroupDecrement setget set_signalGroupDecrement

##Vars for you to set the trigger values
export var upper_threshold = 10
export var lower_threshold = 0
export var value = 0 setget set_value

##If you are using save functions, this enables the node to remember it's state
export var save_state = false

## Set functions to help when editing in Editor
func set_signalsToIncrement(value):
	if len(value) > len(signalsToIncrement) and value[len(value)-1] == []:
		signalsToIncrement.append([NodePath(),'SignalName'])
	else:
		signalsToIncrement = value
		
func set_signalsToDecrement(value):
	if len(value) > len(signalsToDecrement) and value[len(value)-1] == []:
		signalsToDecrement.append([NodePath(),'SignalName'])
	else:
		signalsToDecrement = value
		
func set_signalGroupIncrement(value):
	if len(value) > len(signalGroupIncrement) and value[len(value)-1] == []:
		signalGroupIncrement.append(['BaseName','SignalName',0])
	else:
		signalGroupIncrement = value
		
func set_signalGroupDecrement(value):
	if len(value) > len(signalGroupDecrement) and value[len(value)-1] == []:
		signalGroupDecrement.append(['BaseName','SignalName',0])
	else:
		signalGroupDecrement = value


## In Ready function we connect all signals
func _ready():
	
	for sti in signalsToIncrement:
		var node = get_node(sti[0])
		if not node:
			print('increment node not found:' + sti[0])
			continue
		node.connect(sti[1],self,'increment')
		
	for std in signalsToDecrement:
		var node = get_node(std[0])
		if not node:
			print('increment node not found:' + std[0])
			continue
		node.connect(std[1],self,'decrement')
		
	for sgnG in signalGroupIncrement:
		var baseName = sgnG[0]
		var signalT = sgnG[1]
		var size = sgnG[2]
		for cs in range(size):
			var node = get_node(baseName + str(cs))
			if not node:
				print('Group Increment node ',baseName,' ',cs,' not found')
				continue
			node.connect(signalT,self,'increment')
			
	for sgnG in signalGroupDecrement:
		var baseName = sgnG[0]
		var signalT = sgnG[1]
		var size = sgnG[2]
		for cs in range(size):
			var node = get_node(baseName + str(cs))
			if not node:
				print('Group Increment node ',baseName,' ',cs,' not found')
				continue
			node.connect(signalT,self,'decrement')

## Setter for value
func set_value(vl):
	value = vl
	if value >= upper_threshold:
		emit_signal("upper_limit")
	elif value <= lower_threshold:
		emit_signal("lower_limit")

## Function to call on signals
func increment():
	self.value +=1

func decrement():
	self.value -=1

## If you are using your own save functions, feel free to modify these ones
## Below

## in case of using save states, here we return a dict with the node's value
func save():
	if not save_state:
		return null
	return {'value':value}
	

func _load(data):
	if data:
		self.value = data['value']
