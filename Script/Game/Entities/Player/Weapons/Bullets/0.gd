extends Spatial

var speed 
var size
var maxrange
var delta
var dir
var damage


func init(_spread, _color, _damage = 0):#, _special = {}):
	rotate_y(_spread.y)
	rotate_x(_spread.x)
	damage = _damage
	speed = float(speed)/1000
	get_node("Timer").wait_time = maxrange/speed
	
	#$Sprite.resource_local_to_scene = true
	$Sprite.modulate = _color
	#$CSGBox.material.emission = $CSGBox.material.albedo_color


func hit(body):
	if body is Player:
		body.hurt(damage, true)#, _special = {}):
	queue_free()
		#:D


func _ready():
	if is_network_master():
		get_node("Area").connect("body_entered", self, "hit")


func _process(d):
	delta = d * 60
	translate(Vector3(delta*speed, 0, 0))

 
func _on_Timer_timeout():
	queue_free()
