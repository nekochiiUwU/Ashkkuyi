class_name Player
extends KinematicBody

onready var _inventory = load("res://Scenes/Game/UI/Inventory.tscn").instance()
onready var _bullet = load("res://Scenes/Game/Entities/Player/Weapons/Bullets/0.tscn")

onready var p = get_parent()
onready var cursor = p.get_node("Cursor")
onready var camera = p.get_node("Camera")
onready var UI = camera.get_node("Canvas/UI")
onready var visual = get_node("Visual")
onready var hitbox = get_node("Collision")
onready var camera_pos = get_node("CameraPos")
onready var animation_player = get_node("Animation Player")

var online = {
	"Weapon": [],
	"Hp": 1000,
	"Shield": 500,
	"Mana": 1000,
	"Frame": 0,
	"Position": Vector3(),
	"Flip h": false
}

const GRAVITY    = -1000
var jump_height  = 750
var weight       = 50
var gravity      = 0
var speed        = 250
var speedtick    = speed

var data: Dictionary 
var Name
var hp = 1000
var max_hp = 1000
var shield = 500
var max_shield = 500
var mana = 1000
var max_mana = 1000

var l_click_pressed = false
var r_click_pressed = false
var jump            = false

var cursor_pos = Vector3(20, -0.15, 20)
var sensibility= 1000

var cursor_type= 0

var inventory_open = false


var animations = {
	"Jump": false,
	"Fall": false,
	"Crouch": false,
	"to_Crouch": false,
	"Run": false,
}

var colors: Dictionary = {
	"Hairs": Color(0, 1, 1),
	"Skin": Color(0, 1, 1),
	"Shirt": Color(0, 1, 1),
	"Pants": Color(0, 1, 1),
	"Shoes": Color(0, 1, 1),
}

var inventory = [0, 0, 0, 0, 0, 0, 0, 0, 0,
				 0, 0, 0, 0, 0, 0, 0, 0, 0]
#var equiped = [Weapon.instance(), Weapon.instance(), Weapon.instance()]

var dir   : Vector3 = Vector3()
var vector: Vector3 = Vector3(0, 0.01, 0)
var rota  : Vector3 = Vector3()


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


func update_hp():
	UI.get_node("Health").rect_size.x = 12 + (float(hp) / max_hp) * 460
	UI.get_node("Shield").rect_size.x = 12 + (float(shield) / max_shield) * 460


func move(delta):
	if not is_on_floor():
		dir /= 10
	if gravity:
		vector += Vector3(0, gravity, 0)
	if dir:
		vector += dir.normalized() * speedtick
	if vector:
		vector = move_and_slide(vector * delta, Vector3.UP)
	
	if not is_on_floor():
		if gravity > GRAVITY:
			gravity += 0.05 * GRAVITY
		if vector.y < 0:
			animations["Fall"] = true
			animations["Jump"] = false
		else:
			animations["Fall"] = false
			animations["Jump"] = true
	else:
		animations["Fall"] = false
		animations["Jump"] = false
		gravity = -50 #0.05 * GRAVITY
		if Input.is_action_just_pressed("jump"):
			gravity = jump_height
	vector = Vector3()


func _input(event):
	if event is InputEventMouseMotion:
		var motion = Vector3(-event.relative.y - event.relative.x, 0, -event.relative.y + event.relative.x) * 1 / sensibility
		cursor_pos += motion
		camera.get_node("RayCast").rotate_x(-event.relative.y * 1 / sensibility)
		camera.get_node("RayCast").rotate_y(-event.relative.x * 1 / sensibility)
		print(camera.get_node("RayCast").rotation_degrees.y)
		camera.get_node("RayCast").rotation_degrees.x = clamp(
			camera.get_node("RayCast").rotation_degrees.x, -10, 6)
		camera.get_node("RayCast").rotation_degrees.y = clamp(
			camera.get_node("RayCast").rotation_degrees.y, -14, 14)


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
		dir.z -= 1
		dir.x -= 1
		animations["Run"] = true
	if Input.is_action_pressed("move_up"):
		dir.z += 1
		dir.x += 1
		animations["Run"] = true
	if Input.is_action_pressed("crouch"):
		animations["to_Crouch"] = true
		hitbox.shape.height = 0.45
		hitbox.translation = Vector3(0, -0.55, 0)
		speedtick /= 3
	else:
		animations["Crouch"] = false
		animations["to_Crouch"] = false
		hitbox.shape.height = 0.6
		hitbox.translation = Vector3(0, -0.6, 0)
	
	if Input.is_action_just_pressed("inventaire"):
		if not inventory_open:
			camera.get_node("Canvas").add_child(_inventory)
			inventory_open = true
			Input.set_mouse_mode(0)
		else:
			camera.get_node("Canvas").remove_child(_inventory)
			inventory_open = false
			Input.set_mouse_mode(2)
	
	if Input.is_mouse_button_pressed(2):
		r_click_pressed = true
	else:
		r_click_pressed = false
	
	if r_click_pressed:
		camera_pos.global_transform.origin = Vector3(
			(translation.x*3 + cursor.translation.x)/4 -20, 17.5
			, (translation.z*3 + cursor.translation.z)/4 -20)
	else:
		camera_pos.global_transform.origin = Vector3(translation.x-20, 16 + translation.y, translation.z-20)


func set_variables():
	hp = online["Hp"]
	shield = online["Shield"]
	mana = online["Mana"]
	for i in visual.get_children():
		i.flip_h = online["Flip h"]
		i.frame = online["Frame"]
	translation = online["Position"]
	if online["Weapon"]:
		$Weapon.transform.basis.x = online["Weapon"][0]
		$Weapon.special = online["Weapon"][1]
		$Weapon.bullet_color = online["Weapon"][2]


func send_variables():
	online["Hp"] = hp
	online["Shield"] = shield
	online["Mana"] = mana
	online["Frame"] = visual.get_child(0).frame
	online["Position"] = translation
	online["Weapon"] = []
	for i in get_children():
		if i.name == "Weapon":
			online["Weapon"] = [i.transform.basis.x, i.special, i.bullet_color]
	online["Flip h"] = visual.get_child(0).flip_h
	rset_unreliable('online', online)


remote func fire(bullet_name, color, speed, size, maxrange, orientation):
	var bullet = _bullet.instance()
	bullet.transform = $Weapon/Visual.get_global_transform()
	bullet.transform.origin += Vector3(0.2, 0, 0).rotated(Vector3.UP, bullet.transform.basis.y)
	bullet.speed = speed
	bullet.size = size
	bullet.maxrange = maxrange
	bullet.init(orientation, color)
	bullet.name = bullet_name
	bullet.get_node("Area").monitoring = false
	get_parent().add_child(bullet)


remote func hurt(damage, initiating, special = {}):
	if initiating:
		rpc("hurt", damage, false, special)
	if shield:
		shield -= damage
		if shield < 0:
			hp -= shield
			shield = 0
	else:
		hp -= damage
	update_hp()


func init(d, is_slave):
	rset_config("online", 1)
	#rset_config("fire", 1)
	data = d
	if typeof(d["Position"]) ==  typeof("Spawn"):
		d["Position"] = Vector3(rand_range(-10, 10), 3, rand_range(-10, 10))
	else:
		d["Position"] = Vector3(d["Position"][0], d["Position"][1], d["Position"][2])
	
	for i in visual.get_children():
		i.texture = load("res://Assets/Visual/Entities/Player/Parts/"+i.name+"/"+d[i.name][0]+".png")
		i.modulate = Color(data[i.name][1])
	
	if not is_slave:
		cursor.visible = true
		camera.enabled = true
		$Listener.make_current()


func _process(delta):
	if is_network_master():
		local_process(delta)
		send_variables()
	else:
		set_variables()
	if get_tree().is_network_server():
		Network.update_data(int(p.name), data)


func local_process(delta):
	speedtick = speed
	get_input()
	cursor.translation = camera.get_node("RayCast").get_collision_point()
	cursor.translation.y += 1.3
	update_animations()


func _physics_process(delta):
	if is_network_master():
		move(delta)
