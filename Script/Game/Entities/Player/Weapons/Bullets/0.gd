extends Spatial

var speed = 0.3
var delta
var dir
var damage = 1
var up = Vector3(0, 1, 0)

func init(_transform, _color, _damage = 1, _special = {}):
	transform = _transform
	damage = _damage
	
	#$Sprite.resource_local_to_scene = true
	$Sprite.modulate = _color
	#$CSGBox.material.emission = $CSGBox.material.albedo_color

func _process(d):
	delta = d * 60
	translate(Vector3(delta*speed, 0, 0))
 


func _on_Timer_timeout():
	queue_free()
