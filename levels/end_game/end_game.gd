extends Control

signal cleared
signal restart


func _on_play_again() -> void:
	emit_signal("cleared")
