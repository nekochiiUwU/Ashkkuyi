class_name Weapon
extends RigidBody

var liste_armes_names = ["FA", "LMG", "P", "SMG", "R", "SG", "S"]
var liste_armes_types = ["FA", "SA","B", "SG"]

"""var liste_armes = {
	"FA": {
		"damages": 0,
		"type": 0,
		"manacost": 0,
		"firerate": 0,
		"magazine_size": 0,
		"reload_time": 0,
		"accuracy": 0,
		"velocity": 0,
		"calibre": 0,
		"recoil": 0,
		"max_range": 0
	},
	"F": {
		"damages": 0,
		"type": 0,
		"manacost": 0,
		"firerate": 0,
		"magazine_size": 0,
		"reload_time": 0,
		"accuracy": 0,
		"velocity": 0,
		"calibre": 0,
		"recoil": 0,
		"max_range": 0
	},
	"FAE": {
		"damages": 0,
		"type": 0,
		"manacost": 0,
		"firerate": 0,
		"magazine_size": 0,
		"reload_time": 0,
		"accuracy": 0,
		"velocity": 0,
		"calibre": 0,
		"recoil": 0,
		"max_range": 0
	},
	"FAZ": {
		"damages": 0,
		"type": 0,
		"manacost": 0,
		"firerate": 0,
		"magazine_size": 0,
		"reload_time": 0,
		"accuracy": 0,
		"velocity": 0,
		"calibre": 0,
		"recoil": 0,
		"max_range": 0
	},
	"FAA": {
		"damages": 0,
		"type": 0,
		"manacost": 0,
		"firerate": 0,
		"magazine_size": 0,
		"reload_time": 0,
		"accuracy": 0,
		"velocity": 0,
		"calibre": 0,
		"recoil": 0,
		"max_range": 0
	},
	"FAQ": {
		"damages": 0,
		"type": 0,
		"manacost": 0,
		"firerate": 0,
		"magazine_size": 0,
		"reload_time": 0,
		"accuracy": 0,
		"velocity": 0,
		"calibre": 0,
		"recoil": 0,
		"max_range": 0
	},
	"FAW": {
		"damages": 0,
		"type": 0,
		"manacost": 0,
		"firerate": 0,
		"magazine_size": 0,
		"reload_time": 0,
		"accuracy": 0,
		"velocity": 0,
		"calibre": 0,
		"recoil": 0,
		"max_range": 0
	},
	"FAX": {
		"damages": 60,
		"type": 0,
		"manacost": 0,
		"firerate": 0,
		"magazine_size": 0,
		"reload_time": 0,
		"accuracy": 0,
		"velocity": 0,
		"calibre": 0,
		"recoil": 0,
		"max_range": [0,6]
		
		
		
			var weapon_name = random
			damages = rng.randfn(liste_armes[weapon_name]["damages"] * pow(level, 0.5), luck)
			type = rng.randfn(liste_armes[weapon_name]["type"] * pow(level, 0.5), luck)
			manacost = rng.randfn(liste_armes[weapon_name]["manacost"] * pow(level, 0.5), luck)
			firerate = rng.randfn(liste_armes[weapon_name]["firerate"] * pow(level, 0.5), luck)
			magazine_size = rng.randfn(liste_armes[weapon_name]["magazine_size"] * pow(level, 0.5), luck)
			current_ammo = magazine_size
			reload_time = rng.randfn(liste_armes[weapon_name]["reload_time"] * pow(level, 0.5), luck)
			accuracy = rng.randfn(liste_armes[weapon_name]["accuracy"] * pow(level, 0.5), luck)
			velocity = rng.randfn(liste_armes[weapon_name]["velocity"] * pow(level, 0.5), luck)
			calibre = rng.randfn(liste_armes[weapon_name]["calibre"] * pow(level, 0.5), luck)
			recoil = rng.randfn(liste_armes[weapon_name]["recoil"][0] * pow(level, 0.5), luck)
			max_range = rng.randfn(60 * pow(level, 0.5), luck)}}"""


var arme
var damages
var type
var manacost
var firerate
var magazine_size
var current_ammo
var reload_time
var accuracy
var velocity
var calibre
var recoil
var recoil_recover
var max_range

var stats: Array

#var current_recoil
func export_stats():
	if arme[0] == 0:
		stats = [arme, damages, type, manacost, firerate, magazine_size, 
		current_ammo, reload_time, accuracy, velocity, calibre, 
		recoil, recoil_recover, max_range]


func loot_weapon(level, luck):
	level = float(level)
	luck = float(luck)
	var random = liste_armes_names[rand_range(0, 0)]
	arme = Vector2(0, random)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	if random == "FA":
		damages       = round(rng.randfn(60 * pow(level, 0.5), luck/60 * 60)*100)/100
		type          = "FA"
		manacost      = round(rng.randfn(30 * pow(level, 0.5), luck/60 * 30)*100)/100
		firerate      = round(rng.randfn(6 * pow(level, 0.5), luck/60 * 6)*100)/100
		magazine_size = round(rng.randfn(20 * pow(level, 0.5), luck/60 * 20)*100)/100
		current_ammo  = magazine_size
		reload_time   = round(rng.randfn(4 * pow(level, 0.5), luck/60 * 4)*100)/100
		accuracy      = round(rng.randfn(5 * pow(level, 0.5), luck/60 * 5)*100)/100
		velocity      = round(rng.randfn(400 * pow(level, 0.5), luck/60 * 400)*100)/100
		calibre       = round(rng.randfn(1 * pow(level, 0.5), luck/60 * 1)*100)/100
		recoil        = round(rng.randfn(1 * pow(level, 0.5), luck/60 * 1)*100)/100
		recoil_recover= round(rng.randfn(60 * pow(level, 0.5), luck/60 * 60)*100)/100
		max_range     = round(rng.randfn(300 * pow(level, 0.5), luck/60 * 300)*100)/100
		var stats = [damages, type, manacost]
		print(stats)
		
	elif liste_armes_names[random] == "LMG":
		pass
	#lsite export
	export_stats()


func loot_cac(level, luck):
	pass
func loot_spell(level, luck):
	pass
func loot_mov(level, luck):
	pass


func init(position, level, luck, is_new = true):
	translate(position)
	if is_new:
		var random = rand_range(0, 100)
		if random <= 100:
			loot_weapon(level, luck)
		elif random <= 65:
			loot_cac(level, luck)
		elif random <= 85:
			loot_spell(level, luck)
		else:
			loot_mov(level, luck)


func _ready():
	pass
