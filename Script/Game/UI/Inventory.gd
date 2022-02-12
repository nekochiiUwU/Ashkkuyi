extends Node2D

onready var player
onready var s

var selected_node 
var hovering_node 
var prev

var misc: Array

var spe: Array

var first_run = true

func show_stats(node):
	if node:
		print("entered")
	else:
		print(node)


func update():
	for s in range(len(player.inventory)-1):
		for i in range(len(player.inventory[s])):
			if player.inventory[s][i]:
				print(player.inventory[s][i][0])
				get_node("Background/Set "+str(s)+"/"+str(i)+"/ButtonSlot/TextureRect").visible = true
				get_node("Background/Set "+str(s)+"/"+str(i)+"/ButtonSlot/TextureRect").frame_coords = Vector2(player.inventory[s][i][0][1], player.inventory[s][i][0][0])
			else:
				get_node("Background/Set "+str(s)+"/"+str(i)+"/ButtonSlot/TextureRect").visible = false
	update_stats_player()


func update_stats_player():
	s = get_node("Background/Stats")
	s.get_node("Level").text = "Level :"+str(player.level)
	s.get_node("Misc points").text = "Misc points :"+str(player.misc_points)
	s.get_node("Spe points").text = "Spe points :"+str(player.spe_points)
	print(misc, "\n", spe)
	if player.misc_points:
		for i in misc:
			s.get_node("Statistics/" + i).text = i + ": " + str(player.stats[i])
			s.get_node("Statistics/" + i + "/Upgrade").visible = true
	else:
		for i in misc:
			print(s.get_node("Statistics/" + i))
			s.get_node("Statistics/" + i).text = i + ": " + str(player.stats[i])
			s.get_node("Statistics/" + i + "/Upgrade").visible = false
	
	"""if player.spe_points:
		for i in spe:
			s.get_node("Statistics/" + i).text = i + ": " + str(player.stats[i])
			s.get_node("Statistics/" + i + "/Upgrade").visible = true
	else:
		for i in spe:
			s.get_node("Statistics/" + i).text = i + ": " + str(player.stats[i])
			s.get_node("Statistics/" + i + "/Upgrade").visible = false"""

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
		print("unget")
	elif selected_node == null:
		selected_node = new_selected_node
		update_stats_select(player.inventory[coordonates.y][coordonates.x])
		print("get")
	else:
		prev = get_node("../../")
		if new_selected_node.y == 4:
			prev.get_node("ColorRect/Set "+str(new_selected_node.y)+"/"+str(new_selected_node.x)+"/ButtonSlot").pressed = false
			get_node("Background/Set "+str(selected_node.y)+"/"+str(selected_node.x)+"/ButtonSlot").pressed = false
			if player.inventory[selected_node.y][selected_node.x]:
				print('cqsfqsds')
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
				print('cqsfqsds')
				prev.object.import_stats(player.inventory[new_selected_node.y][new_selected_node.x])
				prev.update_prev(player.inventory[new_selected_node.y][new_selected_node.x])
			else:
				prev.object.queue_free()
				player.preview_open = false
				prev.get_parent().remove_child(prev)
		else:
			get_node("Background/Set "+str(new_selected_node.y)+"/"+str(new_selected_node.x)+"/ButtonSlot").pressed = false
			get_node("Background/Set "+str(selected_node.y)+"/"+str(selected_node.x)+"/ButtonSlot").pressed = false
		print("swap")
		print(player.inventory)
		var temp = player.inventory[selected_node.y][selected_node.x]
		player.inventory[selected_node.y][selected_node.x] = player.inventory[new_selected_node.y][new_selected_node.x]
		player.inventory[new_selected_node.y][new_selected_node.x] = temp
		print(player.inventory)
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
		player.misc_points -= 1
	else:
		player.spe_points -= 1
	

func _ready():
	pass

func _enter_tree():
	if get_parent().name == "Canvas":
		player = get_node("../../../Player")
	else:
		player = get_node("../../../../../Player")
	if first_run:
		misc = player.stats.keys()
		spe = player.ranged_stats.keys() + \
			  player.cac_stats.keys()    + \
			  player.spell_stats.keys()  + \
			  player.mov_stats.keys()
		var pos = Vector2(0, 24)
		var _node = load("res://Scenes/Game/UI/Asset/Statistic.tscn")
		for i in spe + misc:
			var node = _node.instance()
			node.name = i
			node.rect_position = pos
			pos.y += node.rect_size.y
			get_node("Background/Stats/Statistics").add_child(node)
			get_node("Background/Stats/Statistics/" + i + "/Upgrade").connect("Upgrade", self, "_on_Up_pressed")
			first_run = false
	update()



func _process(delta):
	pass








