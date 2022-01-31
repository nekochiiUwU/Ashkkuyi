extends Node

var SERVER_IP = '127.0.0.1'#172.17.28.158
var SERVER_PORT = 62319
var MAX_PLAYERS = 3

var players = {}
# Change
var self_data: Dictionary

func create_server(data):
	self_data = data
	players[1] = self_data
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	print("IP:\t", IP.get_local_addresses()[3], "\nPort:\t", SERVER_PORT)
	get_tree().network_peer = peer

func connect_to_server(data):
	self_data = data
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer

func _connected_to_server():
	players[get_tree().get_network_unique_id()] = self_data
	rpc('_send_player_info', get_tree().get_network_unique_id(), self_data)

func update_data(id, data):
	players[id] = data

remote func _send_player_info(id, data):
	if get_tree().is_network_server():
		for peer_id in players:
			rpc_id(id, '_send_player_info', peer_id, players[peer_id])
	players[id] = data
	var new_player = load('res://Scenes/Game/Entities/Player/Player.tscn').instance()
	new_player.name = str(id)
	new_player.get_child(0).set_network_master(id)
	print(get_tree().get_root().get_node("/root/Node2D/Game/Navigation"))
	get_tree().get_root().get_node("/root/Node2D/Game/Navigation").add_child(new_player)
	print(new_player.get_parent().name)
	new_player.get_child(0).init(data, true)


func _process(delta):
	pass
