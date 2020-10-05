extends TextureButton


func _on_pause_state(paused: bool) -> void:
	if paused:
		hide()
	else:
		show()
