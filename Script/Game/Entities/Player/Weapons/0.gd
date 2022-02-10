extends Spatial

onready var player = get_parent()
onready var cursor = get_node("../../Cursor")
onready var _bullet = preload("res://Scenes/Game/Entities/Player/Weapons/Bullets/0.tscn")
"""
	var AUTO = 3
	var auto = 3

	var AUTO_CHANNEL = 3
	var auto_channel = 3

	var BULLETS = 30
	var bullets = 30

	var AUTOSPEED = 3
	var autospeed = 3

	var speed = 300
	var maxrange = 150
	var size = Vector2(1, 1)
	var spread = Vector2(0, 0)

	var CHANNEL = 60
	var channel = 60

	var cost = 2

	var click_pressed = true
	var damage = 50
	var special = {"poison": [0.01, 5]}
	var bullet_color = Color(0, 1, 0)
	var cursor_type = 0
	"""

var s


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

var reload_time_left = 0
var current_recoil
var has_shot
var is_in_burst
var special
var bullet_color = Color(1, 1, 1)

func update_weapon():
	s = player.inventory[player.active_set][player.active_weapon]
	if s:
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
			
			current_recoil = 0
			get_node("Visual").frame_coords = Vector2(arme.y, arme.x)
			visible = true
	else:
		visible = false

func _process(delta):
	if is_network_master():
		transform.basis.x = -(global_transform.origin - cursor.translation).normalized()
		if arme:
			if Input.is_action_just_pressed("reload") and current_ammo != magazine_size:
				if not player.mana < manacost:
					player.mana -= manacost
					reload_time_left = reload_time
					rotation_degrees.y = 200
					
			if not reload_time_left:
				if not has_shot:
					if not(type[0] != "B" and is_in_burst):
						print("success !")
						if Input.is_mouse_button_pressed(1):
							if type[0] == "FA":
								shoot()
						else:
							pass
							#recoil -= 60/delta*recoil_recover
							#faire baisser le recoil jusqu'a 0 en recoil_recover frames(base 60 fps)
					else:
						shoot()
						is_in_burst -= 1
						if is_in_burst == 0:
							current_recoil += recoil
				else:
					has_shot -= delta*60
					if has_shot <= 0:
						has_shot = 0
			else:
				reload_time_left -= delta*60
				if reload_time_left <= 0:
					current_ammo = magazine_size
					reload_time_left = 0
					rotation_degrees.y = 135

func shoot():
	print(current_ammo)
	if current_ammo:
		has_shot = firerate
		current_ammo -= 1
		current_recoil += recoil
		
		player.vector -= Vector3(transform.basis.x.x, 0, transform.basis.x.z) * damages
		var b = _bullet.instance()
		b.transform = $Visual.get_global_transform()
		b.transform.origin += Vector3(0.3, 0, 0).rotated(Vector3.UP, rotation.y)
		b.velocity = velocity
		b.max_range = max_range
		b.calibre = calibre
		var offset = Vector2(rand_range(-current_recoil, current_recoil)+rand_range(-accuracy, accuracy),0)
		b.init(offset, bullet_color, damages)
		player.get_parent().add_child(b)
		player.update()
		get_parent().rpc_unreliable("fire", b.name, bullet_color, velocity, b.calibre, b.max_range, offset)

func update():
	pass
