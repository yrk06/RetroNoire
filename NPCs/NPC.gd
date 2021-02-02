extends KinematicBody2D

signal truth_revealed
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

var options = 2

var state = {
	'angry':false,
	'defeated':false,
}

var persistent_reference = null

var location
# Called when the node enters the scene tree for the first time.
func _ready():
	if location:
		position = location



func interact():
	if Type == NPC_Types.IRRELEVANTE:
		UiInterface.abrir_text_box(dialogs['dialogo Inicial'],name)
		return
	if state['angry']:
		UiInterface.abrir_text_box(dialogs['recusa'],name)
		return
	if state['defeated']:
		UiInterface.abrir_text_box(dialogs['verdade'],name)
		return
	UiInterface.abrir_text_box_com_opcoes(dialogs["dialogo Inicial"],options,self,'handle_response',name)
	pass

func handle_response(res):
	match res:
		0: ## Até mais
			UiInterface.abrir_text_box(dialogs['later'],name)
			return
		1: ## Concordar
			UiInterface.abrir_text_box(dialogs['concordar'],name)
			if Type == NPC_Types.BOM:
				emit_signal("truth_revealed")
		2: ## Duvida
			if Type == NPC_Types.NEUTRO:
				emit_signal("truth_revealed")
				state['defeated'] = true
				UiInterface.abrir_text_box(dialogs['doubt']+dialogs['verdade'],name)
			else:
				state['angry'] = true
				
				UiInterface.abrir_text_box(dialogs['doubt']+dialogs['recusa'],name)
			
		3: ## Mentir
			if Type == NPC_Types.MAU:
				emit_signal("truth_revealed")
				state['defeated'] = true
				UiInterface.abrir_text_box(dialogs['lie']+dialogs['verdade'],name)
			else:
				state['angry'] = true
				UiInterface.abrir_text_box(dialogs['lie']+dialogs['recusa'],name)
	persistent_reference.update_state(state)

func set_frames(pack,variant):
	$AnimatedSprite.frames = pack
	$AnimatedSprite.animation = variant

