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

##Abre uma textbox com espaço pra seleções. além disso chama <callback> em <node>
# com o numero da opcão selecionada
func abrir_text_box_com_opcoes(dialogo,opcoes,node,callback):
	var txt_node = get_node('/root/MainTree/UI/UIControl/TextBoxes')
	txt_node.wOptions(dialogo,opcoes,node,callback)
	txt_node.visible = true
	PlayerInterface.take_player_control()
	pass

##Abre uma textbox padrão
func abrir_text_box(dialogo):
	var txt_node = get_node('/root/MainTree/UI/UIControl/TextBoxes')
	txt_node.classic(dialogo)
	txt_node.visible = true
	PlayerInterface.take_player_control()
	pass


