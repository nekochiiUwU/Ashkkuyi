extends Node2D

var selected_node 
var hovering_node 

func show_stats(node):
	if node:
		print("entered")
	else:
		print(node)

func _on_ButtonSlot_pressed(coordonates):
	var new_selected_node = coordonates#get_node("Set "+str(coordonates.y)+"/"+str(coordonates.x)+"/ButtonSlot")#/TextureRect")
	if new_selected_node == selected_node:
		selected_node = null
		print("unget")
	elif selected_node == null:
		selected_node = new_selected_node
		print("get")
	else:
		get_node("Set "+str(new_selected_node.y)+"/"+str(new_selected_node.x)+"/ButtonSlot").pressed = false
		get_node("Set "+str(selected_node.y)+"/"+str(selected_node.x)+"/ButtonSlot").pressed = false
		print("swap")
		var player
		if get_parent().name == "Canvas":
			player = get_node("../../../Player")
		else:
			player = get_node("../../../../../Player")
		print(player.inventory)
		var temp = player.inventory[selected_node.y][selected_node.x]
		player.inventory[selected_node.y][selected_node.x] = player.inventory[new_selected_node.y][new_selected_node.x]
		player.inventory[new_selected_node.y][new_selected_node.x] = temp
		print(player.inventory)
		selected_node = null

func _on_ButtonSlot_mouse_entered(coordonates):
	hovering_node = get_node("Set "+str(coordonates.y)+"/"+str(coordonates.x)+"/ButtonSlot")
	show_stats(coordonates)

func _on_ButtonSlot_mouse_exited(coordonates):
	hovering_node = null
	show_stats(null)

func _ready():
	pass

func _process(delta):
	pass





