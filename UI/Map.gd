extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var map_center = Vector2(-10,5.0)

var pois = []
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not visible:
		return
	if Input.is_action_just_pressed("ui_accept"):
		visible = false
	convert_player_position(PlayerInterface.get_player_outside_position())

func convert_player_position(p_pos):
	var start_pos = -p_pos
	start_pos.x *= 170/1027.0
	start_pos.y *= 43/256.0
	print(start_pos)
	$MapTexture.rect_position = map_center + start_pos

func load_POI(dict):
	var location = Vector2(dict["location"]["x"],dict["location"]["y"])
	var instance = preload("res://UI/MapPoint.tscn").instance()
	$MapTexture.add_child(instance)
	instance.rect_position = location
	instance.visible = true if (dict["visible"] if "visible" in dict else false)  else false
	instance.set_text(dict['text'])
	instance.name = dict['text']
	pois.append(dict)
		
func show_POI(poi_name):
	$MapTexture.get_node(poi_name).visible = true
	for p in pois:
		if p["text"] == poi_name:
			p['visible'] = true
	UiInterface.display_text(poi_name + " "+tr("GAME_MAPA"))

func save_data():
	return pois
	
func load_data(vpois):
	for p in vpois:
		load_POI(p)
