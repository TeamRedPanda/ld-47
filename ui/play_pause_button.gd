extends Button


func _on_pause_state(paused: bool) -> void:
	if paused:
		self.text = "Play"
	else:
		self.text = "Pause"
