extends KinematicBody

slave var data = {'position': Vector3()}


func local_process(delta):
	translation.x += 0.1


func set_variables():
	translation = data['position']

func send_variables():
	var data = {
		'position': translation
	}
	rset_unreliable('online', data)

func init(d, is_slave):
	translation = d["Position"]
	data = d

func _process(delta):
	if is_network_master():
		local_process(delta)
		send_variables()
	else:
		set_variables()
	if get_tree().is_network_server():
		Network.update_data(int(name), data)
