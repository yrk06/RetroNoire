extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var disp = TranslationServer.get_loaded_locales()
	print(TranslationServer.get_locale())
	var c_idx = disp.find(TranslationServer.get_locale())+1
	if c_idx >= len(disp):
		c_idx -= len(disp)
	TranslationServer.set_locale(disp[c_idx])
	UiInterface.search_cases()
