extends Spatial

onready var music = get_node("Music")
var time = 0
var tempo = 60000/160

func _on_Music_finished(node):
	node += "/" + str(int(rand_range(0, len(music.get_node(node).get_children()))))
	for track in music.get_node(node).get_children():
		track.play()
	time = 0

func _process(delta):
	time += delta
	time = get_node("Music/Base/0/Chill").get_playback_position()
	$thing.mesh.height = (-((float(int(time * 1000) % tempo)) / (tempo))) * 0.08 + 0.16
	$thing.mesh.radius = (-((float(int(time * 1000) % tempo)) / (tempo))) * 0.04 + 0.08
	#$thing.speed_scale = 10

func run():
	var player = load('res://Scenes/Game/Entities/Player/Player.tscn').instance()
	player.name = str(get_tree().get_network_unique_id())
	player.set_network_master(int(player.name))
	get_node("Navigation").add_child(player)
	player.get_child(0).init(Network.self_data, false)
	player.get_child(1).current = true
