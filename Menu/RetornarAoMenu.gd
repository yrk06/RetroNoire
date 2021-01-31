extends Control

# var cases = get(res://case_files/) <- alterar a chamada para os casos

func _on_Button_pressed():
	get_tree().change_scene('res://Menu/MenuInicial.tscn')

func _on_OptionButton_pressed():
	var select_case = get_node("CenterContainer/VBoxContainer/OptionButton")
	pass
	# for item in cases:
	#	select_case.add_item(item) <- adicionar os casos na lista

func _on_OptionButton_item_selected(index):
	pass
	# get_tree().change_scene(index)
