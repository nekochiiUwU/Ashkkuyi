extends Node2D

onready var player = get_node("Player")
onready var ui = get_node("UI")
const UNAUTORISED_CHARACTERS = ["\n"]
const NEEDED_CHARACTERS = ["a", "A"]
var name_available = false
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
	_on_TextEdit_text_changed()


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
	name_available = false
	var text_edit = ui.get_node("TextEdit")
	var pos = text_edit.cursor_get_column()
	var text = ""
	var t = text_edit.text
	t.split("")
	for i in t:
		if not i in UNAUTORISED_CHARACTERS:
			text += i
		if i in NEEDED_CHARACTERS:
			name_available = true
	pos = len(text_edit.get_line(0))
	text_edit.text = text
	text_edit.cursor_set_column(pos)


func _on_End_pressed():
	if name_available == false:
		print("Name Unautorised")
		return 1
	create_character()
	get_tree().change_scene("res://Scenes/Menu/Main Menu.tscn")


func create_character():
	var fileid = 0
	var data = []
	var file = File.new()
	
	file.open("res://Data/Characters/.meta.gd", File.READ)
	while not file.eof_reached():
		data.append(file.get_line())
	file.close()
	
	while str(fileid) in data:
		fileid += 1
	print(data)
	data.append(str(fileid))
	
	for i in range(len(data)-1):
		i+=1
		data[0] += "\n" + str(data[i])
	data = data[0]
	
	file.open("res://Data/Characters/.meta.gd", File.WRITE)
	file.store_string(data)
	file.close()
	
	data = ui.get_node("TextEdit").text + "\n"
	for i in player.get_children():
		data += str(parts[i.name][0]) + "\n"
		data += str(parts[i.name][1].r) + "\n"
		data += str(parts[i.name][1].g) + "\n"
		data += str(parts[i.name][1].b) + "\n"
	data += "[]\n[]\n[]"
	#       pos-inventory
	file.open("res://Data/Characters/" + str(fileid) + ".txt", File.WRITE)
	file.store_string(data)
	file.close()
