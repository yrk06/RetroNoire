extends KinematicBody2D


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

var persistent_reference = null

var location
# Called when the node enters the scene tree for the first time.
func _ready():
	if location:
		position = location



func interact():
	if Type == NPC_Types.IRRELEVANTE:
		UiInterface.abrir_text_box(dialogs['dialogo Inicial'])
		return
	if state['angry']:
		UiInterface.abrir_text_box(dialogs['recusa'])
		return
	if state['defeated']:
		UiInterface.abrir_text_box(dialogs['verdade'])
		return
	UiInterface.abrir_text_box_com_opcoes(dialogs["dialogo Inicial"],options,self,'handle_response')
	pass

func handle_response(res):
	match res:
		0: ## Até mais
			UiInterface.abrir_text_box(dialogs['later'])
			return
		1: ## Concordar
			UiInterface.abrir_text_box(dialogs['concordar'])
			return
		2: ## Duvida
			if Type == NPC_Types.NEUTRO:
				state['defeated'] = true
				UiInterface.abrir_text_box(dialogs['doubt']+dialogs['verdade'])
			else:
				state['angry'] = true
				
				UiInterface.abrir_text_box(dialogs['doubt']+dialogs['recusa'])
			
		3: ## Mentir
			if Type == NPC_Types.MAU:
				state['defeated'] = true
				UiInterface.abrir_text_box(dialogs['lie']+dialogs['verdade'])
			else:
				state['angry'] = true
				UiInterface.abrir_text_box(dialogs['lie']+dialogs['recusa'])
	#persistent_reference.update_state(state)

func set_frames(pack,variant):
	$AnimatedSprite.frames = pack
	$AnimatedSprite.animation = variant

