extends Area2D

signal player_entered
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect('body_entered',self,'_on_ZtoInteract_body_entered')


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ZtoInteract_body_entered(body):
	emit_signal("player_entered")
