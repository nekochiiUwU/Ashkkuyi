class_name Player
extends KinematicBody

onready var _inventory = load("res://Scenes/Game/UI/Inventory.tscn").instance()

onready var p = get_parent()
onready var cursor = p.get_node("Cursor")
onready var camera = p.get_node("Camera")
onready var visual = get_node("Visual")
onready var hitbox = get_node("Collision")
onready var camera_pos = get_node("CameraPos")
onready var animation_player = get_node("Animation Player")

const GRAVITY    = -1000
var jump_height  = 750
var weight       = 50
var gravity      = 0
var speed        = 250
var speedtick    = speed

var data: Dictionary 
var Name

var l_click_pressed = false
var r_click_pressed = false
var jump            = false

var cursor_pos = Vector3(20, -0.15, 20)
var sensibility= 100

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
		hitbox.shape.height = 1.45
		hitbox.translation = Vector3(0, -0.55, 0)
		speedtick /= 3
	else:
		animations["Crouch"] = false
		animations["to_Crouch"] = false
		hitbox.shape.height = 1.6
		hitbox.translation = Vector3(0, -0.475, 0)
	
	if Input.is_action_just_pressed("inventaire"):
		if not inventory_open:
			camera.add_child(_inventory)
			inventory_open = true
			Input.set_mouse_mode(0)
		else:
			camera.remove_child(_inventory)
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
		camera_pos.global_transform.origin = Vector3(translation.x-20, 17.5, translation.z-20)

func move(delta):
	if not is_on_floor():
		dir /= 10
	if gravity:
		vector += Vector3(0, gravity, 0)
	if dir:
		vector += dir.normalized() * speedtick
	if vector:
		vector = move_and_slide(vector * delta, Vector3(0, 1, 0))
	
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


func local_process(delta):
	speedtick = speed
	get_input()
	cursor.translation = cursor_pos + camera.translation
	cursor.translation.y -= camera.translation.y - 0.7
	cursor.translation.x = clamp(cursor.translation.x, translation.x - 15, translation.x + 15)
	cursor.translation.z = clamp(cursor.translation.z, translation.z - 15, translation.z + 15)
	update_animations()


func set_variables():
	translation = data["Position"]
	print(data["Position"])

func send_variables():
	rset_unreliable('data', data)


func _input(event):
	if event is InputEventMouseMotion:
		var motion = Vector3(-event.relative.y - event.relative.x, 0, -event.relative.y + event.relative.x) * 1 / sensibility
		cursor_pos += motion


func init(d, is_slave):
	rset_config("data", 1)
	if typeof(d["Position"]) ==  typeof("Spawn"):
		d["Position"] = Vector3(10, 3, 0)
	else:
		d["Position"] = Vector3(d["Position"][0], d["Position"][1], d["Position"][2])
	data = d
	for i in visual.get_children():
		i.texture = load("res://Assets/Visual/Entities/Player/Parts/"+i.name+"/"+data[i.name][0]+".png")
		i.modulate = Color(data[i.name][1])


func _process(delta):
	if is_network_master():
		local_process(delta)
		send_variables()
	else:
		set_variables()
	if get_tree().is_network_server():
		Network.update_data(int(get_parent().name), data)


func _physics_process(delta):
	if is_network_master():
		move(delta)
