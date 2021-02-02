extends Control

signal confirmed
signal denied
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var npc = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not visible:
		return
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("denied")
		visible = false
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("interact"):
		yield(get_tree().create_timer(0.01),'timeout')
		emit_signal("confirmed")
		visible = false
	
func set_npc_name(nname):
	$NPC_Name.text = nname
	npc = nname
