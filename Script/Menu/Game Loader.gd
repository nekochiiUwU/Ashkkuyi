extends Node2D

onready var _Game = preload("res://Scenes/Game/Game.tscn")
var pdata: Dictionary = {
	# Main
	"Name": "",     # Nom          | 1
	"Position": "", # Position     | 3
	"Slots"   : "", # Inventaire   | 15
	
	# Etat
	"Status": "",# HP   Shild  ...| 5
	"Effects":"",# Stun Brulure...| ??
	
	# Stat
	"Stats": "",    # Stat        | 6
	"RangedWpn": "",# Stat d'arme | 5
	"Spells": "",   # Stat d'arme | 5
	"MeleeWpn": "", # Stat d'arme | 5
	"Movements": "",# Stat d'arme | 3
	
	# Skin
	"Back": "",  # Skin           | 2
	"Skin": "",  # Skin           | 2
	"Shoes": "", # Skin           | 2
	"Pants": "", # Skin           | 2
	"Shirt": "", # Skin           | 2
	"Face": "",  # Skin           | 2
	"Hairs": "", # Skin           | 2
	"Front": "", # Skin           | 2
}

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
		var line = f.get_line()
		if not ":" in line:
			playerdata.append(line)
	f.close()
	
	pdata["Name"] = playerdata[0]
	pdata["Back"] = [playerdata[1], playerdata[2]]
	pdata["Skin"] = [playerdata[3], playerdata[4]]
	pdata["Shoes"] = [playerdata[5], playerdata[6]]
	pdata["Pants"] = [playerdata[7], playerdata[8]]
	pdata["Shirt"] = [playerdata[9], playerdata[10]]
	pdata["Face"] = [playerdata[11], playerdata[12]]
	pdata["Hairs"] = [playerdata[13], playerdata[14]]
	pdata["Front"] = [playerdata[15], playerdata[16]]
	pdata["Position"] = playerdata[17]
	pdata["Slots"] = [playerdata[18], playerdata[19], playerdata[20], playerdata[21], playerdata[22], playerdata[23], playerdata[24], playerdata[25], playerdata[26], playerdata[27], playerdata[28], playerdata[29], playerdata[30], playerdata[31], playerdata[32]]
	pdata["Stats"] = playerdata[33]
	pdata["RangedWpn"] = playerdata[34]
	pdata["Spells"] = playerdata[35]
	pdata["MeleeWpn"] = playerdata[36]
	pdata["Movements"] = playerdata[37]
	pdata["Status"] = playerdata[38]
	pdata["State"] = playerdata[39]
	
	if pdata["Position"] != "Spawn":
		playerdata = pdata["Position"].split(", ")
		pdata["Position"] = []
		for i in playerdata:
			pdata["Position"].append(int(i))
	
	playerdata = pdata["Stats"].split(", ")
	pdata["Stats"] = []
	for i in playerdata:
		pdata["Stats"].append(int(i))
	
	playerdata = pdata["RangedWpn"].split(", ")
	pdata["RangedWpn"] = []
	for i in playerdata:
		pdata["RangedWpn"].append(int(i))
	
	playerdata = pdata["Spells"].split(", ")
	pdata["Spells"] = []
	for i in playerdata:
		pdata["Spells"].append(int(i))
	
	playerdata = pdata["MeleeWpn"].split(", ")
	pdata["MeleeWpn"] = []
	for i in playerdata:
		pdata["MeleeWpn"].append(int(i))
	
	playerdata = pdata["Movements"].split(", ")
	pdata["Movements"] = []
	for i in playerdata:
		pdata["Movements"].append(int(i))
	
	playerdata = pdata["Status"].split(", ")
	pdata["Status"] = []
	for i in playerdata:
		pdata["Status"].append(int(i))
	
	playerdata = pdata["State"].split(", ")
	pdata["State"] = []
	for i in playerdata:
		if i:
			pdata["State"].append(int(i))
	
	if data[0] == "1":
		Network.create_server(pdata)
	else:
		Network.connect_to_server(pdata)
	
	var game = _Game.instance()
	add_child(game)
	game.run()
	
	#replace_by(game)
	#get_child(0).replace_by_instance()
	
