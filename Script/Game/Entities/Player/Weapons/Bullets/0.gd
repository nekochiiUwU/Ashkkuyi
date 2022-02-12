extends Spatial

var velocity 
var calibre
var max_range
var delta
var dir
var damage


func init(_spread, _color, _damage = 0):#, _special = {}):
	#rotate_y((_spread.y)/360*2*PI)
	rotate_x((_spread.x)/360*2*PI)
	damage = _damage
	velocity = float(velocity)/1000
	get_node("Timer").wait_time = max_range/velocity
	
	#$Sprite.resource_local_to_scene = true
	$Sprite.modulate = _color
	#$CSGBox.material.emission = $CSGBox.material.albedo_color


func hit(body):
	if body is Player and body != get_node("../Player"):
		body.hurt(damage, true)#, _special = {}):
	if body != get_node("../Player"):
		queue_free()
		#:D


func _ready():
	if is_network_master():
		get_node("Area").connect("body_entered", self, "hit")


func _process(d):
	delta = d * 60
	translate(Vector3(delta*velocity, 0, 0))

 
func _on_Timer_timeout():
	queue_free()
