extends Node

##Aqui chamamos quando queremos abrir a UI

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

## Functions

func abrir_menu_analise(sprite,analise):
	var analise_node = get_node('/root/MainTree/UI/UIControl/Analise')
	if analise_node.visible:
		analise_node.visible = false
		PlayerInterface.give_player_movement()
		return
	analise_node.visible = true
	analise_node.get_node('MarginContainer/VBoxContainer/HBoxContainer/Img').texture = sprite
	analise_node.get_node('MarginContainer/VBoxContainer/Label').text = analise
	PlayerInterface.take_player_movement()
