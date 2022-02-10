extends Node2D

onready var player

var selected_node 
var hovering_node 
var prev

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
				get_node("Set "+str(s)+"/"+str(i)+"/ButtonSlot/TextureRect").visible = true
				get_node("Set "+str(s)+"/"+str(i)+"/ButtonSlot/TextureRect").frame_coords = Vector2(player.inventory[s][i][0][1], player.inventory[s][i][0][0])
			else:
				get_node("Set "+str(s)+"/"+str(i)+"/ButtonSlot/TextureRect").visible = false

func _on_ButtonSlot_pressed(coordonates):
	var new_selected_node = coordonates#get_node("Set "+str(coordonates.y)+"/"+str(coordonates.x)+"/ButtonSlot")#/TextureRect")
	if new_selected_node == selected_node:
		selected_node = null
		print("unget")
	elif selected_node == null:
		selected_node = new_selected_node
		print("get")
	else:
		prev = get_node("../../")
		if new_selected_node.y == 4:
			prev.get_node("ColorRect/Set "+str(new_selected_node.y)+"/"+str(new_selected_node.x)+"/ButtonSlot").pressed = false
			get_node("Set "+str(selected_node.y)+"/"+str(selected_node.x)+"/ButtonSlot").pressed = false
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
			get_node("Set "+str(new_selected_node.y)+"/"+str(new_selected_node.x)+"/ButtonSlot").pressed = false
			if player.inventory[new_selected_node.y][new_selected_node.x]:
				print('cqsfqsds')
				prev.object.import_stats(player.inventory[new_selected_node.y][new_selected_node.x])
				prev.update_prev(player.inventory[new_selected_node.y][new_selected_node.x])
			else:
				prev.object.queue_free()
				player.preview_open = false
				prev.get_parent().remove_child(prev)
		else:
			get_node("Set "+str(new_selected_node.y)+"/"+str(new_selected_node.x)+"/ButtonSlot").pressed = false
			get_node("Set "+str(selected_node.y)+"/"+str(selected_node.x)+"/ButtonSlot").pressed = false
		print("swap")
		print(player.inventory)
		var temp = player.inventory[selected_node.y][selected_node.x]
		player.inventory[selected_node.y][selected_node.x] = player.inventory[new_selected_node.y][new_selected_node.x]
		player.inventory[new_selected_node.y][new_selected_node.x] = temp
		print(player.inventory)
		selected_node = null
		update()
		player.update_set()

func _on_ButtonSlot_mouse_entered(coordonates):
	hovering_node = get_node("Set "+str(coordonates.y)+"/"+str(coordonates.x)+"/ButtonSlot")
	show_stats(coordonates)

func _on_ButtonSlot_mouse_exited(coordonates):
	hovering_node = null
	show_stats(null)

func _ready():
	pass

func _enter_tree():
	if get_parent().name == "Canvas":
		player = get_node("../../../Player")
	else:
		player = get_node("../../../../../Player")
	update()
	

func _process(delta):
	pass





