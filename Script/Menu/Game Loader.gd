extends Node2D


func _ready():
	var data = []
	
	var f = File.new()
	
	f.open("res://temp.txt", File.READ)
	while not f.eof_reached():
		data.append(f.get_line())
	f.close()
	
	f.open("res://Data/Characters/" + data[1] + ".txt", File.READ)
	var playerdata = []
	while not f.eof_reached():
		playerdata.append(f.get_line())
	f.close()
	print(playerdata)
