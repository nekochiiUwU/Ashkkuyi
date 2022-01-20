extends Node2D

onready var character_selector = get_node("Select Character")


func _ready():
	pass

func _process(delta):
	pass


func _on_Play_pressed():
	pass


func _on_Create_Character_pressed():
	get_tree().change_scene("res://Scenes/Menu/Character Personalisation.tscn")


func _on_Select_Character_item_selected(index):
	pass
