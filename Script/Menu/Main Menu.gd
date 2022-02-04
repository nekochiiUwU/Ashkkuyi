extends Node2D

onready var character_selector = get_node("Select Character")


func _ready():
	var rng = RandomNumberGenerator.new()
	var fileid = 0
	var data = []
	var file = File.new()
	
	file.open("res://Data/Characters/.meta.gd", File.READ)
	while not file.eof_reached():
		data.append(file.get_line())
	
	file = data
	data = []
	for i in file:
		if i:
			var f = File.new()
			f.open("res://Data/Characters/"+i+".txt", File.READ)
			f.get_line()
			data.append([f.get_line(), int(i)])
			f.close()
	for i in data:
		print(i)
		$"Select Character".add_item(i[0], i[1])


func _process(delta):
	pass


func _on_Create_Character_pressed():
	get_tree().change_scene("res://Scenes/Menu/Character Personalisation.tscn")


func _on_Select_Character_item_selected(index):
	pass


func _on_Host_pressed():
	if $"Select Character".selected is int:
		var f = File.new()
		f.open("res://temp.txt", File.WRITE)
		f.store_string(str(1) + "\n" + str($"Select Character".selected))
		f.close()
		get_tree().change_scene("res://Scenes/Menu/Game Loader.tscn")


func _on_Join_pressed():
	if $"Select Character".selected is int:
		var f = File.new()
		f.open("res://temp.txt", File.WRITE)
		f.store_string(str(0) + "\n" + str($"Select Character".selected))
		f.close()
		get_tree().change_scene("res://Scenes/Menu/Game Loader.tscn")
