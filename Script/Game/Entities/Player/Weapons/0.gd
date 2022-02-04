extends Spatial

onready var player = get_parent()
onready var cursor = get_node("../../Cursor")
onready var _bullet = preload("res://Scenes/Game/Entities/Player/Weapons/Bullets/0.tscn")

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

var cost = 20

var click_pressed = true
var damage = 50
var special = {"poison": [0.01, 5]}
var bullet_color = Color(0, 1, 0)
var cursor_type = 0

func _process(delta):
	if is_network_master():
		transform.basis.x = -(global_transform.origin - cursor.translation).normalized()
		if not autospeed < 0:
			autospeed -= delta * 60
		if not channel < 0:
			channel -= delta * 60
		if not auto_channel < 0:
			auto_channel -= delta * 60

		if Input.is_mouse_button_pressed(1):
			if bullets:
				if channel < 0 and auto_channel < 0:
					if auto or not click_pressed:
						if autospeed < 0:
							shoot()
							auto -= 1
							bullets -= 1
							autospeed = AUTOSPEED
			click_pressed = true
		else:
			if not auto:
				auto_channel = AUTO_CHANNEL
				auto = AUTO
			if not bullets:
				channel = CHANNEL
				bullets = BULLETS
			auto = AUTO
			click_pressed = true

func shoot():
	if not player.mana < cost:
		player.vector -= Vector3(transform.basis.x.x, 0, transform.basis.x.z) * 200
		player.mana -= cost
		var b = _bullet.instance()
		b.transform = $Visual.get_global_transform()
		b.transform.origin += Vector3(0.3, 0, 0).rotated(Vector3.UP, rotation.y)
		b.speed = speed
		b.maxrange = maxrange
		b.size = size
		b.init(spread, bullet_color, damage)
		player.get_parent().add_child(b)
		player.update()
		get_parent().rpc_unreliable("fire", b.name, bullet_color, speed, b.size, b.maxrange, spread)
