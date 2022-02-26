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
var type: Array
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

func update():
	get_node("Sprite3D").frame_coords = Vector2(arme.y, arme.x)
	
#var current_recoil
func export_stats():
	if arme[0] == 0:
		stats = [arme, damages, type, manacost, firerate, magazine_size, 
		current_ammo, reload_time, accuracy, velocity, calibre, 
		recoil, recoil_recover, max_range]

func import_stats(s):
	if s[0][0] == 0:
		arme = s[0]
		damages = s[1]
		type = s[2]
		manacost = s[3]
		firerate = s[4]
		magazine_size = s[5]
		current_ammo = s[6]
		reload_time = s[7]
		accuracy = s[8]
		velocity = s[9]
		calibre = s[10]
		recoil = s[11]
		recoil_recover = s[12]
		max_range = s[13]
		update()

func scaling_function(level):
	return pow(2, level/20)


func loot_weapon(level, luck):
	level = float(level)
	luck = float(luck)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	arme = Vector2(0, rng.randi_range(0, 6))
	var which = liste_armes_names[arme.y]
	get_node("Sprite3D").frame_coords = Vector2(arme.y, arme.x)
	#if random == "FA":
	if which:
		damages       = round(rng.randfn(60    * scaling_function(level), luck/60 * 60)*100)/100
		type          = ["FA"]
		manacost      = round(rng.randfn(20    / scaling_function(level), luck/60 * 30)*100)/100
		firerate      = round(rng.randfn(6     * scaling_function(level), luck/60 * 6)*100)/100
		magazine_size = round(rng.randfn(20    * scaling_function(level), luck/60 * 20))
		current_ammo  = magazine_size
		reload_time   = round(rng.randfn(4     / scaling_function(level), luck/60 * 4)*100)/100
		accuracy      = round(rng.randfn(5     / scaling_function(level), luck/60 * 5)*100)/100
		velocity      = round(rng.randfn(400   * scaling_function(level), luck/60 * 400)*100)/100
		calibre       = round(rng.randfn(1     * scaling_function(level), luck/60 * 1)*100)/100
		recoil        = round(rng.randfn(1     / scaling_function(level), luck/60 * 1)*100)/100
		recoil_recover= round(rng.randfn(60    / scaling_function(level), luck/60 * 60)*100)/100
		max_range     = round(rng.randfn(300   * scaling_function(level), luck/60 * 300)*100)/100
		var stats = [damages, type, manacost]
		print(stats)
		
	#elif liste_armes_names[which] == "LMG":
		#pass
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
