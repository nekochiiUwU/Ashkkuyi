extends Node
"""
onready var player_name = get_node("Player Name")
var data: Dictionary = {name = "KEKW", position = Vector3()}
func _on_Create_pressed():
	if player_name.text != '':
		data.name = player_name.text
		Network.create_server(data)
		get_tree().change_scene("res://multi/Game.tscn")

func _on_Join_pressed():
	if player_name.text != '':
		data.name = player_name.text
		Network.connect_to_server(data)
		get_tree().change_scene("res://multi/Game.tscn")
"""
