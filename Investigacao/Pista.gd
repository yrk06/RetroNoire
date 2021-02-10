extends Node2D


export (Texture) var sprite

export (String) var analise

signal pista_pega
## Por enquanto = self
var persistent_reference = null

var state = {
	'investigada':false
}

var location
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if location:
		position = location
	$Sprite.texture = sprite
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	yield(get_tree().create_timer(rng.randi_range(0,5)),'timeout')
	$AnimatedSprite.play("sparkle")

func interact():
	if not state['investigada'] and persistent_reference:
		persistent_reference.trigger()
		emit_signal("pista_pega")
	state['investigada'] = true
	UiInterface.abrir_menu_analise(sprite,analise)


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.stop()
	$AnimatedSprite.frame = 0
	get_tree().create_timer(5).connect("timeout",$AnimatedSprite,'play',['sparkle'])
