tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("Logic Counter", "Node", preload("LogicCounter.gd"), preload("LogicCounter.png"))
	add_custom_type("Logic Relay", "Node", preload("LogicRelay.gd"), preload("LogicRelay.png"))


func _exit_tree():
	remove_custom_type("Logic Counter")
	remove_custom_type("Logic Relay")
