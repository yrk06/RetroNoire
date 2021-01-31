extends Button

export(String) var function_to_call

func _on_pressed():
	Game.call(function_to_call)
