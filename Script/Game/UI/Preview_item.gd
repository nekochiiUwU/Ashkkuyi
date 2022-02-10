extends Node2D

onready var player = get_node("../../../Player")
var selected_weapon: Array

var object

func update_prev(s):
	print(s)
	
	var text_edit = get_node("ColorRect/1/TextEdit")
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
	get_node("ColorRect/Set 4/0/ButtonSlot/TextureRect").frame_coords = Vector2(s[0].y, s[0].x)

func init(weap):
	print(player)
	object = weap
	var s = weap.stats
	player.inventory[4][0] = s
	update_prev(s)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
