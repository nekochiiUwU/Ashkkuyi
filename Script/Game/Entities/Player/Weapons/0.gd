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

var CHANNEL = 60
var channel = 60

var click_pressed = true
var damage = 10
var special = {"poison": [0.01, 5]}
var bullet_color = Color(0, 1, 0)
var cursor_type = 0

func _process(delta):
	transform.basis.x =-(
							player.translation - 
							(
								cursor.translation + 
								cursor.get_child(cursor_type).translation
							)
						).normalized()
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
	player.vector -= Vector3(transform.basis.x.x, 0, transform.basis.x.z) * 200
	var b = _bullet.instance()
	b.init($Visual.get_global_transform(), bullet_color, damage, special)
	player.get_parent().add_child(b)
