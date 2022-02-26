class_name Player
extends KinematicBody

onready var _inventory       = load("res://Scenes/Game/UI/Inventory.tscn").instance()
onready var _preview         = load("res://Scenes/Game/UI/Preview_item.tscn").instance()
onready var _bullet          = load("res://Scenes/Game/Entities/Player/Weapons/Bullets/0.tscn")
onready var p                = get_parent()
onready var cursor           = p.get_node("Cursor")
onready var camera           = p.get_node("Camera")
onready var UI               = camera.get_node("Canvas/UI")
onready var weapon           = get_node("Weapon")
onready var visual           = get_node("Visual")
onready var hitbox           = get_node("Collision")
onready var camera_pos       = get_node("CameraPos")
onready var animation_player = get_node("Animation Player")

var online:             Dictionary = {
									  "Weapon": [],
									  "Hp": 1000,
									  "Shield": 500,
									  "Mana": 1000,
									  "Frame": 0,
									  "Position": Vector3(),
									  "Flip h": false
}

var animations:         Dictionary = {
									  "Jump": false,
									  "Fall": false,
									  "Crouch": false,
									  "to_Crouch": false,
									  "Run": false
}

var colors:             Dictionary = {
									  "Hairs": Color(0, 1, 1),
									  "Skin": Color(0, 1, 1),
									  "Shirt": Color(0, 1, 1),
									  "Pants": Color(0, 1, 1),
									  "Shoes": Color(0, 1, 1)
}

var stats:              Dictionary = {
									  "Hp": [1000.0, 100.0, 5.0, 1],
									  "Shield": [1000.0, 100.0, 5.0, 1],
									  "Mana": [1000.0, 100.0, 5.0, 1],
									  "Speed": [250.0, 100.0, 5.0, 1],
									  "Aerial Swiftness": [100, 100.0, 5.0, 1],
									  "Luck": [1.0, 100.0, 5.0, 1],
									  "Vision": [1.0, 100.0, 5.0, 1],

									  "Ranged damages": [100.0, 70.0, 5.0, 1],
									  "Firerate": [100.0, 70.0, 5.0, 1],
									  "Accuracy": [100.0, 70.0, 5.0, 1],
									  "Reload": [100.0, 70.0, 5.0, 1],
									  "Recoil": [100.0, 70.0, 5.0, 1],

									  "Cac damages": [100.0, 70.0, 5.0, 1],
									  "Travel time": [100.0, 70.0, 5.0, 1],
									  "Size": [100.0, 70.0, 5.0, 1],
									  "Length": [100.0, 70.0, 5.0, 1],
									  "Boldness": [100.0, 70.0, 5.0, 1],

									  "Spell damages": [100.0, 70.0, 5.0, 1],
									  "Channel": [100.0, 70.0, 5.0, 1],
									  "Range": [100.0, 70.0, 5.0, 1],
									  "CDR": [100.0, 70.0, 5.0, 1],
									  "Manacost": [100.0, 70.0, 5.0, 1],

									  "Cringe percent": [100.0, 70.0, 5.0, 1],
									  "Dexterity": [100.0, 70.0, 5.0, 1],
									  "Recovery": [100.0, 70.0, 5.0, 1],
}

var data:               Dictionary

const GRAVITY           = -1000
var weight              = 50
var gravity             = 0
var jump_height         = 750

var Name                = ""
var current_hp          = 1000.0
var current_shield      = 500.0
var current_mana        = 100.0

var inventory:    Array = [[0, 0, 0, 0, 0, 0], 
						   [0, 0, 0], [0, 0, 0], [0, 0, 0], 
						   [0]
]

var active_set          = 1
var active_weapon       = 0

var level               = 1
var misc_points         = 50
var spe_points          = 0

var sensibility         = 1000

var speedtick           = 250 + stats["Speed"][0]*(stats["Speed"][1]/100)

var l_click_pressed     = false
var r_click_pressed     = false
var jump                = false

var inventory_open      = false
var preview_open        = false
var cursor_type         = 0
var cursor_pos: Vector3 = Vector3(20, -0.15, 20)

var dir   :     Vector3 = Vector3()
var vector:     Vector3 = Vector3(0, 0.01, 0)

func stat(stat):
	return stats[str(stat)][0] * (stats[str(stat)][1]/100)

func hide_body(body):
	body.visible = false


func show_body(body):
	body.visible = true


func update_animations():
	if animations["Jump"]:
		animation_player.play("Jump")
	elif animations["Fall"]:
		animation_player.play("Fall")
	elif animations["to_Crouch"]:
		if animations["Run"]:
			animation_player.play("Crouch Run")
		else:
			animation_player.play("Crouch")
		animations["Run"] = false
	elif animations["Run"]:
		animation_player.play("Run")
		animations["Run"] = false
	else:
		animation_player.play("Stand")


func update():
	UI.get_node("ActiveSet/"+str(active_weapon)+"/ColorRect").rect_size.y = 40*(weapon.reload_time_left/weapon.reload_time)
	UI.get_node("Health").rect_size.x = 12 + (float(current_hp) / stat("Hp")) * 460
	UI.get_node("Shield").rect_size.x = 12 + (float(current_shield) / stat("Shield")) * 460
	UI.get_node("Mana Font/Mana").material.set_shader_param("offset", -(float(current_mana) / stat("Mana")) + 0.5)


func update_set():
	for i in range(3):
		if inventory[active_set][i]:
			UI.get_node("ActiveSet/" + str(i) + "/TextureRect").visible = true
			UI.get_node("ActiveSet/" + str(i) + "/TextureRect").frame_coords = Vector2(inventory[active_set][i][0][1], inventory[active_set][i][0][0])
		else:
			UI.get_node("ActiveSet/" + str(i) + "/TextureRect").visible = false
	for i in range(3):
		if inventory[(active_set)%3+1][i]:
			UI.get_node("NextSet/" + str(i) + "/TextureRect").visible = true
			UI.get_node("NextSet/" + str(i) + "/TextureRect").frame_coords = Vector2(inventory[(active_set)%3+1][i][0][1], inventory[(active_set)%3+1][i][0][0])
		else:
			UI.get_node("NextSet/" + str(i) + "/TextureRect").visible = false
	weapon.update_weapon()


func move(delta):
	if dir:
		if not is_on_floor():
			print(stat("Aerial Swiftness"))
			vector += dir.normalized() * speedtick * (stat("Aerial Swiftness")/100)
		else:
			vector += dir.normalized() * speedtick
	if gravity:
		vector += Vector3(0, gravity, 0)
	if vector:
		vector = move_and_slide(vector * delta, Vector3.UP)
	
	if not is_on_floor():
		if gravity > GRAVITY:
			gravity += (weight * 0.001) * GRAVITY
		if vector.y < 0:
			animations["Fall"] = true
			animations["Jump"] = false
		else:
			animations["Fall"] = false
			animations["Jump"] = true
	else:
		animations["Fall"] = false
		animations["Jump"] = false
		gravity = (weight * 0.001) * GRAVITY
		if Input.is_action_just_pressed("jump"):
			gravity = jump_height * (1+(stat("Aerial Swiftness")/100-1))
	vector = Vector3()


func _input(event):
	if event is InputEventMouseMotion:
		var motion = Vector3(-event.relative.y - event.relative.x, 0, -event.relative.y + event.relative.x) * 1 / sensibility
		cursor_pos += motion
		camera.get_node("RayCast").rotate_x(-event.relative.y * 1 / sensibility)
		camera.get_node("RayCast").rotate_y(-event.relative.x * 1 / sensibility)
		camera.get_node("RayCast").rotation_degrees.x = clamp(
			camera.get_node("RayCast").rotation_degrees.x, -10, 6)
		camera.get_node("RayCast").rotation_degrees.y = clamp(
			camera.get_node("RayCast").rotation_degrees.y, -14, 14)
	
	elif event is InputEventMouseButton:
		if event.button_index == 5: 
			active_weapon = (active_weapon + 1)%3
			print(active_weapon)
			UI.get_node("ActiveSet/Select").rect_position.x = 40 + active_weapon*96
			weapon.update_weapon()
		elif event.button_index == 4: 
			active_weapon = (active_weapon - 1)%3
			if active_weapon < 0:
				 active_weapon += 3
			print(active_weapon)
			UI.get_node("ActiveSet/Select").rect_position.x = 40 + active_weapon*96
			weapon.update_weapon()


func get_input():
	dir = Vector3()
	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("mouse_lock"):
		if Input.get_mouse_mode():
			Input.set_mouse_mode(0)
		else:
			Input.set_mouse_mode(2)
	
	if Input.is_action_pressed("move_right"):
		dir.z += 1
		dir.x -= 1
		animations["Run"] = true
		if visual.get_child(0).flip_h:
			for i in visual.get_children():
				if i.name != "Animation Player":
					i.flip_h = false
	if Input.is_action_pressed("move_left"):
		dir.z -= 1
		dir.x += 1
		animations["Run"] = true
		if not visual.get_child(0).flip_h:
			for i in visual.get_children():
				if i.name != "Animation Player":
					i.flip_h = true
	if Input.is_action_pressed("move_down"):
		dir.z            -= 1
		dir.x            -= 1
		animations["Run"] = true
	if Input.is_action_pressed("move_up"):
		dir.z            += 1
		dir.x            += 1
		animations["Run"] = true
	
	if Input.is_action_pressed("crouch"):
		animations["to_Crouch"] = true
		hitbox.shape.height     = 0.45
		hitbox.translation      = Vector3(0, -0.55, 0)
		speedtick              /= 3
	else:
		animations["Crouch"]    = false
		animations["to_Crouch"] = false
		hitbox.shape.height     = 0.6
		hitbox.translation      = Vector3(0, -0.6, 0)
	
	if Input.is_action_just_pressed("interact"):
		if not preview_open:
			var object = []
			for body in get_node("Area").get_overlapping_bodies():
				if not object:
					object = [body, transform.origin.distance_to(body.transform.origin)]
				elif transform.origin.distance_to(body.transform.origin) < object[1]:
					object = [body, transform.origin.distance_to(body.transform.origin)]
			if object and object[0] is Weapon:
				object = object[0]
				camera.get_node("Canvas").add_child(_preview)
				_preview.init(object)
				preview_open = true
				Input.set_mouse_mode(0)
		else:
			preview_open = false
			camera.get_node("Canvas").remove_child(_preview)
			weapon.update_weapon()
			Input.set_mouse_mode(2)
	
	if Input.is_action_just_pressed("inventaire"):
		if not inventory_open and not preview_open:
			camera.get_node("Canvas").add_child(_inventory)
			inventory_open = true
			Input.set_mouse_mode(0)
		else:
			if inventory_open:
				camera.get_node("Canvas").remove_child(_inventory)
				inventory_open = false
			if preview_open:
				camera.get_node("Canvas").remove_child(_preview)
				preview_open = false
			update_set()
			Input.set_mouse_mode(2)
	
	if Input.is_action_just_pressed("next_weapon"):
		active_weapon += 1
		active_weapon %= 3
	if Input.is_action_just_pressed("next_set"):
		active_set    %= 3 
		active_set    += 1 
		update_set()
		
	if Input.is_mouse_button_pressed(2):
		r_click_pressed = true
	else:
		r_click_pressed = false
	
	if r_click_pressed:
		camera_pos.global_transform.origin  = translation
		camera_pos.global_transform.origin += cursor.translation*stat("Vision")
		camera_pos.global_transform.origin /= stat("Vision")+1
		camera_pos.global_transform.origin += Vector3(-20, 16, -20)
	else:
		camera_pos.global_transform.origin  = translation
		camera_pos.global_transform.origin += Vector3(-20, 16, -20)
	
	if Input.is_key_pressed(KEY_0):
		var uwu = load("res://Scenes/Game/Entities/Arme.tscn").instance()
		var spawn_pos = transform.origin
		spawn_pos.y += 10
		uwu.init(spawn_pos, level, stat("Luck"))
		get_parent().get_parent().add_child(uwu)
	
	if Input.is_key_pressed(KEY_9):
		level += 1
		misc_points += 2
		spe_points += 2
		print(level)


func cooldown(delta):
	if current_mana < stat("Mana"):
		current_mana += delta
		update()
	
	if current_shield < stat("Shield"):
		current_shield += delta * 10
		update()


func user_meta():
	cursor.translation    = camera.get_node("RayCast").get_collision_point()
	cursor.translation.y += 0.8


func loot_arme(stats):
	pass


func set_variables():
	current_hp                = online["Hp"]
	current_shield            = online["Shield"]
	current_mana              = online["Mana"]
	for i in visual.get_children():
		i.flip_h              = online["Flip h"]
		i.frame               = online["Frame"]
	translation               = online["Position"]
	$Weapon.transform.basis.x = online["Weapon"][0]
	$Weapon.special           = online["Weapon"][1]
	$Weapon.bullet_color      = online["Weapon"][2]


func send_variables():
	online["Hp"]       = current_hp
	online["Shield"]   = current_shield
	online["Mana"]     = current_mana
	online["Position"] = translation
	online["Weapon"]   = []
	online["Frame"]    = visual.get_child(0).frame
	online["Flip h"]   = visual.get_child(0).flip_h
	online["Weapon"]   = [weapon.transform.basis.x, {}, Color()]
	rset_unreliable('online', online)


remote func fire(color, Speed, size, maxrange, orientation):
	var bullet                         = _bullet.instance()
	bullet.transform                   = $Weapon/Visual.get_global_transform()
	bullet.transform.origin           += Vector3(0.3, 0, 0).rotated(Vector3.UP, $Weapon.rotation.y)
	bullet.speed                       = Speed
	bullet.size                        = size
	bullet.maxrange                    = maxrange
	bullet.init(orientation, color)
	bullet.get_node("Area").monitoring = false
	get_parent().add_child(bullet)


remote func hurt(damage, initiating, special = {}):
	if current_shield:
		current_shield    -= damage
		if current_shield < 0:
			current_hp    += current_shield
			current_shield = 0
	else:
		current_hp        -= damage
	update()


func init(d, is_slave):
	rset_config("online", 1)
	#rset_config("fire", 1)
	data = d
	if typeof(d["Position"]) ==  typeof("Spawn"):
		d["Position"] = Vector3(rand_range(-10, 10), 3, rand_range(-10, 10))
	else:
		d["Position"] = Vector3(d["Position"][0], d["Position"][1], d["Position"][2])
	
	for i in visual.get_children():
		i.texture  = load("res://Assets/Textures/Entities/Player/Parts/"+i.name+"/"+d[i.name][0]+".png")
		i.modulate = Color(data[i.name][1])
	
	if not is_slave:
		camera.get_node("RayCast/Area").connect("body_entered", self, "hide_body")
		camera_pos.get_node("Area").connect("body_entered", self, "hide_body")
		camera.get_node("RayCast/Area").connect("body_exited", self, "show_body")
		camera_pos.get_node("Area").connect("body_exited", self, "show_body")
		cursor.visible = true
		camera.enabled = true
		$Listener.make_current()
	update()
	update_set()
	weapon.update_weapon()


func _process(delta):
	if is_network_master():
		local_process(delta)
		send_variables()
	else:
		set_variables()
	if get_tree().is_network_server():
		Network.update_data(int(p.name), data)


func local_pre_process():
	speedtick = 250 + stat("Speed")


func local_process(delta):
	local_pre_process()
	cooldown(delta)
	get_input()
	user_meta()
	update_animations()


func _physics_process(delta):
	if is_network_master():
		move(delta)
