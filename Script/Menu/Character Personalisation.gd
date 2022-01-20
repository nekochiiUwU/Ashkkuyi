extends Node2D

onready var player = get_node("Player")
onready var ui = get_node("UI")
var selected_part = "Skin"
var path_parts = "res://Assets/Visual/Entities//Player/Parts/"
var parts: Dictionary = {
	"Face" : [0, Color(1, 1, 1)],
	"Hairs": [0, Color(1, 1, 1)],
	"Shirt": [0, Color(1, 1, 1)],
	"Pants": [0, Color(1, 1, 1)],
	"Shoes": [0, Color(1, 1, 1)],
	"Skin" : [0, Color(1, 1, 1)],
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
