extends Control

var cases = []

func _ready():
	for p in Game.get_files_in_folder("res://case_files"):
		if 'ignore' in p:
			continue
		if '.json' in p:
			var jsonString
			var file = File.new()
			file.open('res://case_files/'+p,File.READ)
			jsonString = file.get_as_text()
			file.close()
			var content = JSON.parse(jsonString).result
			
			cases.append([p.replace('.json',''),content['case_name']])
			
	for p in Game.get_files_in_folder("user://case_files"):
		if 'ignore' in p:
			continue
		if '.json' in p:
				var jsonString
				var file = File.new()
				file.open('user://case_files/'+p,File.READ)
				jsonString = file.get_as_text()
				file.close()
				var content = JSON.parse(jsonString).result
				
				cases.append([p.replace('.json',''),content['case_name']])
	for case in cases:
		$CenterContainer/VBoxContainer/ItemList.add_item(case[1])

func _on_Button_pressed():
	visible = false
	UiInterface.open_menu()




func _on_ItemList_item_selected(index):
	Game.new_game(cases[index][0])
