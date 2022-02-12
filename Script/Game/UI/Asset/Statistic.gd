extends Button

signal Upgrade

func _on_Upgrade_pressed():
	emit_signal("Upgrade", get_parent().name)
