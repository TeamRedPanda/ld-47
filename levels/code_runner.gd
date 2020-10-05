class_name CodeRunner
extends Node

var code: Code = null
var _paused: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func execute_code():
	if not code:
		print("Panic: Trying to call execute_call without a code object.")

	_paused = false

	while not _paused:
		yield(step(), "completed")


func toggle_pause():
	_paused = not _paused


func step():
	yield(code.step(), "completed")


func reset():
	if get_tree().reload_current_scene() != OK:
		print("Panic: Somehow the current scene cannot be reloaded.")
