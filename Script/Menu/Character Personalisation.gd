extends Node2D

onready var player = get_node("Player")
onready var ui = get_node("UI")
const UNAUTORISED_CHARACTERS = ["\n"]
var selected_part = "Skin"
var path_parts = "res://Assets/Visual/Entities//Player/Parts/"
var parts: Dictionary = {
	"Spe F": [0, Color(1, 1, 1)],
	"Face" : [1, Color(1, 1, 1)],
	"Hairs": [1, Color(1, 1, 1)],
	"Shirt": [1, Color(1, 1, 1)],
	"Pants": [1, Color(1, 1, 1)],
	"Shoes": [1, Color(1, 1, 1)],
	"Skin" : [0, Color(1, 1, 1)],
	"Spe B": [0, Color(1, 1, 1)]
} 


func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_ColorPicker_color_changed(color):
	parts[selected_part][1] = color
	player.get_node(selected_part).modulate = parts[selected_part][1]

func _on_Button_pressed(part, value):
	selected_part = part
	parts[selected_part][0] += value
	if value:
		var file = load(path_parts + part + "/" + str(parts[selected_part][0]) + ".png")
		if file:
			player.get_node(part).texture = file
		else:
			parts[selected_part][0] = 0
			file = load(path_parts + part + "/0.png")
			if value < 0:
				while file:
					parts[selected_part][0] += 1
					file = load(path_parts + part + "/" + str(parts[selected_part][0]) + ".png")
				parts[selected_part][0] -= 1
				file = load(path_parts + part + "/" + str(parts[selected_part][0]) + ".png")
			player.get_node(part).texture = file
	ui.get_node(part).text = part + " " + str(parts[selected_part][0])
	ui.get_node("ColorPicker").color = player.get_node(part).modulate


func _on_TextEdit_text_changed():
	var text_edit = ui.get_node("TextEdit")
	var pos = text_edit.cursor_get_column()
	var text = ""
	var t = text_edit.text
	t.split("")
	for i in t:
		if not i in UNAUTORISED_CHARACTERS:
			text += i
	
	pos = len(text_edit.get_line(0))
	text_edit.text = text
	text_edit.cursor_set_column(pos)
	
