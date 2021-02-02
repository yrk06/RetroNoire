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
func abrir_text_box_com_opcoes(dialogo,opcoes,node,callback,pname):
	var txt_node = get_node('/root/MainTree/UI/UIControl/TextBoxes')
	txt_node.wOptions(dialogo,opcoes,node,callback,pname)
	txt_node.visible = true
	PlayerInterface.take_player_control()
	pass

##Abre uma textbox padrão
func abrir_text_box(dialogo,pname):
	var txt_node = get_node('/root/MainTree/UI/UIControl/TextBoxes')
	txt_node.classic(dialogo,pname)
	txt_node.visible = true
	PlayerInterface.take_player_control()
	pass

func display_text(text,holdtime = 1,speed = 1):
	var text_node = get_node('/root/MainTree/UI/UIControl/ScreenText')
	text_node.display_text(text,holdtime,speed)

func fadein():
	var fade_node = get_node('/root/MainTree/UI/UIControl/Fade')
	fade_node.fadein()
	return fade_node
	
func fadeout():
	var fade_node = get_node('/root/MainTree/UI/UIControl/Fade')
	fade_node.fadeout()
	return fade_node
	
func open_map():
	var map_node = get_node('/root/MainTree/UI/UIControl/Map')
	map_node.visible = !map_node.visible

func load_map_poi(dict):
	var map_node = get_node('/root/MainTree/UI/UIControl/Map')
	map_node.load_POI(dict)
	
func map_show_poi(poi):
	var map_node = get_node('/root/MainTree/UI/UIControl/Map')
	map_node.show_POI(poi)
func save_map():
	var map_node = get_node('/root/MainTree/UI/UIControl/Map')
	return map_node.save_data()
func load_map(vpois):
	var map_node = get_node('/root/MainTree/UI/UIControl/Map')
	map_node.load_data(vpois)

func close_menu():
	var menu = get_node('/root/MainTree/UI/UIControl/MenuInicial')
	menu.visible = false
	
func open_menu():
	var menu = get_node('/root/MainTree/UI/UIControl/MenuInicial')
	menu.visible = true

func search_cases():
	var case = get_node('/root/MainTree/UI/UIControl/Menucasos')
	case.search_cases()

func open_cases_menu():
	var case = get_node('/root/MainTree/UI/UIControl/Menucasos')
	case.visible = true
	
func close_case_menu():
	var case = get_node('/root/MainTree/UI/UIControl/Menucasos')
	case.visible = false

func open_confirm_arrest(npc,node=null,callbackC=null,callbackD=null):
	var arrest = get_node('/root/MainTree/UI/UIControl/ConfirmArrest')
	arrest.set_npc_name(npc)
	arrest.visible = true
	if node:
		if callbackC:
			arrest.connect('confirmed',node,callbackC,[arrest])
		if callbackD:
			arrest.connect('denied',node,callbackD,[arrest])

func open_endGame(victory,pistasAchadas,pistaTotal):
	var endgame = get_node('/root/MainTree/UI/UIControl/EndGame')
	endgame.set_info(victory,pistasAchadas,pistaTotal)
	endgame.visible = true

func show_credits():
	var credits = get_node('/root/MainTree/UI/UIControl/Creditos')
	credits.visible = true
