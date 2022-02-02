extends KinematicBody

onready var nav = get_node("..")
onready var rays = get_node("Rays")
onready var _bullet = preload("res://Scenes/Game/Entities/Player/Weapons/Bullets/0.tscn")

var speed = 5
var path = []
var path_node = 0

var fov = deg2rad(180.0)
var rangeov = 15
var regov = deg2rad(3)

func generate_raycasts():
	var ray_count = fov / regov
	for i in ray_count:
		var ray = RayCast.new()
		var angle = regov * (i - ray_count / 2.0)
		ray.cast_to = Vector3.RIGHT.rotated(Vector3.UP, angle) * rangeov
		rays.add_child(ray)
		ray.enabled = true

func ray_detection():
	for i in rays.get_children():
		if i.is_colliding() and i.get_collider() is Player:
			var target = i.get_collider().global_transform.origin
			target.y = global_transform.origin.y
			look_at(target, Vector3.UP)
			rotation_degrees.y += 90
			move_to(target)

func _ready():
	generate_raycasts()

func _physics_process(delta):
	if path_node < path.size():
		var dir = (path[path_node] - global_transform.origin)
		if dir.length() < 1:
			path_node += 1
		else:
			move_and_slide(dir.normalized() * speed, Vector3.UP)

func move_to(pos):
	path = nav.get_simple_path(global_transform.origin, pos)
	path_node = 0

func _on_Timer_timeout():
	ray_detection()
