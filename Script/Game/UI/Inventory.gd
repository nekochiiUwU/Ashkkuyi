extends Node2D

onready var player
onready var s

var selected_node 
var hovering_node 
var prev

var misc: Array = ["Hp", "Shield", "Mana", "Speed", "Aerial Swiftness", "Luck", "Vision"]
var upgrade_cost: Array = [0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 8, 8, 9, 10, 10, 10, 10, 10]

var spe: Array

var first_run = true

func show_stats(node):
	if node:
		pass
	else:
		pass


func update():
	for s in range(len(player.inventory)-1):
		for i in range(len(player.inventory[s])):
			if player.inventory[s][i]:
				get_node("Background/Set "+str(s)+"/"+str(i)+"/ButtonSlot/TextureRect").visible = true
				get_node("Background/Set "+str(s)+"/"+str(i)+"/ButtonSlot/TextureRect").frame_coords = Vector2(player.inventory[s][i][0][1], player.inventory[s][i][0][0])
			else:
				get_node("Background/Set "+str(s)+"/"+str(i)+"/ButtonSlot/TextureRect").visible = false
	update_stats_player()


func update_stats_player():
	get_node("Background/Stats/Level").text = "Level : "+str(player.level)
	get_node("Background/Stats/Misc points").text = "Spe points : "+str(player.misc_points)
	get_node("Background/Stats/Spe points").text = "Spe points : "+str(player.spe_points)
	if first_run:
		var pos = Vector2(0, 24)
		var _node = load("res://Scenes/Game/UI/Asset/Statistic.tscn")
		for i in player.stats.keys():
			var node = _node.instance()
			node.name = i
			node.text = str(i)+" :"
			node.rect_position = pos
			pos.y += node.rect_size.y
			get_node("Background/Stats/Statistics").add_child(node)
			get_node("Background/Stats/Statistics/" + i + "/Upgrade").connect("Upgrade", self, "_on_Up_pressed")
			first_run = false
	else:
		for node in get_node("Background/Stats/Statistics").get_children():
			var i = node.name
			node.get_child(2).text = str(player.stats[i][0]*(player.stats[i][1]/100))+" > "+str(player.stats[i][0]*((player.stats[i][1]+player.stats[i][2])/100))+" | cost : "+str(upgrade_cost[player.stats[i][3]])
			if i in misc:
				if player.misc_points <= upgrade_cost[player.stats[i][3]]:
					node.get_child(1).visible = false
				else:
					node.get_child(1).visible = true
			else:
				if player.spe_points <= upgrade_cost[player.stats[i][3]]:
					node.get_child(1).visible = false
				else:
					node.get_child(1).visible = true


func update_stats_hover(s):
	var text_edit = get_node("Background/Preview Focused/TextEdit")
	if s:
		text_edit.text = "Type d'arme: " + str(s[0]) + "\n" + \
			"Dégâts: " + str(s[1]) + "\n" + \
			"Fonctionnement: " + str(s[2]) + "\n" + \
			"Coût en mana: " + str(s[3]) + "\n" + \
			"Cadence de tir: " + str(s[4]) + "\n" + \
			"Capacité: " + str(s[5]) + "\n" +\
			"Balles actuelles: " + str(s[6]) + "\n" + \
			"Temps de recharge: " + str(s[7]) + "\n" + \
			"Précision: " + str(s[8]) + "\n" + \
			"Vélocité: " + str(s[9]) + "\n" + \
			"Calibre: " + str(s[10]) + "\n" + \
			"Recul: " + str(s[11]) + "\n" + \
			"Temps de récupération du recul: " + str(s[12]) + "\n" + \
			"Range: " + str(s[13]) + "\n"
		get_node("Background/Preview Focused/ButtonSlot/TextureRect").visible = true
		get_node("Background/Preview Focused/ButtonSlot/TextureRect").frame_coords = Vector2(s[0].y, s[0].x)
	else:
		get_node("Background/Preview Focused/ButtonSlot/TextureRect").visible = false
		text_edit.text = ""
		
func update_stats_select(s):
	var text_edit = get_node("Background/Preview Selected/TextEdit")
	if s:
		text_edit.text = "Type d'arme: " + str(s[0]) + "\n" + \
			"Dégâts: " + str(s[1]) + "\n" + \
			"Fonctionnement: " + str(s[2]) + "\n" + \
			"Coût en mana: " + str(s[3]) + "\n" + \
			"Cadence de tir: " + str(s[4]) + "\n" + \
			"Capacité: " + str(s[5]) + "\n" +\
			"Balles actuelles: " + str(s[6]) + "\n" + \
			"Temps de recharge: " + str(s[7]) + "\n" + \
			"Précision: " + str(s[8]) + "\n" + \
			"Vélocité: " + str(s[9]) + "\n" + \
			"Calibre: " + str(s[10]) + "\n" + \
			"Recul: " + str(s[11]) + "\n" + \
			"Temps de récupération du recul: " + str(s[12]) + "\n" + \
			"Range: " + str(s[13]) + "\n"
		get_node("Background/Preview Selected/ButtonSlot/TextureRect").visible = true
		get_node("Background/Preview Selected/ButtonSlot/TextureRect").frame_coords = Vector2(s[0].y, s[0].x)
	else:
		get_node("Background/Preview Selected/ButtonSlot/TextureRect").visible = false
		text_edit.text = ""
		
func _on_ButtonSlot_pressed(coordonates):
	var new_selected_node = coordonates#get_node("Set "+str(coordonates.y)+"/"+str(coordonates.x)+"/ButtonSlot")#/TextureRect")
	if new_selected_node == selected_node:
		selected_node = null
	elif selected_node == null:
		selected_node = new_selected_node
		update_stats_select(player.inventory[coordonates.y][coordonates.x])
	else:
		prev = get_node("../../")
		if new_selected_node.y == 4:
			prev.get_node("ColorRect/Set "+str(new_selected_node.y)+"/"+str(new_selected_node.x)+"/ButtonSlot").pressed = false
			get_node("Background/Set "+str(selected_node.y)+"/"+str(selected_node.x)+"/ButtonSlot").pressed = false
			if player.inventory[selected_node.y][selected_node.x]:
				prev.object.import_stats(player.inventory[selected_node.y][selected_node.x])
				prev.update_prev(player.inventory[selected_node.y][selected_node.x])
			else:
				prev.object.queue_free()
				player.preview_open = false
				prev.get_parent().remove_child(prev)
				
		elif selected_node.y == 4:
			prev.get_node("ColorRect/Set "+str(selected_node.y)+"/"+str(selected_node.x)+"/ButtonSlot").pressed = false
			get_node("Background/Set "+str(new_selected_node.y)+"/"+str(new_selected_node.x)+"/ButtonSlot").pressed = false
			if player.inventory[new_selected_node.y][new_selected_node.x]:
				prev.object.import_stats(player.inventory[new_selected_node.y][new_selected_node.x])
				prev.update_prev(player.inventory[new_selected_node.y][new_selected_node.x])
			else:
				prev.object.queue_free()
				player.preview_open = false
				prev.get_parent().remove_child(prev)
		else:
			get_node("Background/Set "+str(new_selected_node.y)+"/"+str(new_selected_node.x)+"/ButtonSlot").pressed = false
			get_node("Background/Set "+str(selected_node.y)+"/"+str(selected_node.x)+"/ButtonSlot").pressed = false
		var temp = player.inventory[selected_node.y][selected_node.x]
		player.inventory[selected_node.y][selected_node.x] = player.inventory[new_selected_node.y][new_selected_node.x]
		player.inventory[new_selected_node.y][new_selected_node.x] = temp
		selected_node = null
		update_stats_select(0)
		update()
		player.update_set()

func _on_ButtonSlot_mouse_entered(coordonates):
	hovering_node = get_node("Background/Set "+str(coordonates.y)+"/"+str(coordonates.x)+"/ButtonSlot")
	update_stats_hover(player.inventory[coordonates.y][coordonates.x])
	show_stats(coordonates)

func _on_ButtonSlot_mouse_exited(coordonates):
	hovering_node = null
	show_stats(null)

func _on_Up_pressed(stat):
	if stat in misc:
		player.misc_points -= upgrade_cost[player.stats[str(stat)][3]]
	else:
		player.spe_points -= upgrade_cost[player.stats[str(stat)][3]]
	player.stats[str(stat)][1] += player.stats[str(stat)][2]
	player.stats[str(stat)][3] += 1
	update_stats_player()
	
	

func _ready():
	pass

func _enter_tree():
	if get_parent().name == "Canvas":
		player = get_node("../../../Player")
	else:
		player = get_node("../../../../../Player")
	update_stats_player()
	update()



func _process(delta):
	pass








