extends Node2D


export (Texture) var small_sprite
export (Texture) var big_sprite

export (String) var analise

var state = {
	'investigada':false
}
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = small_sprite


func interact():
	state['investigada'] = true
	UiInterface.abrir_menu_analise(big_sprite,analise)
