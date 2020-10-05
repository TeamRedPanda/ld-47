class_name CodeRunner
extends Node

signal step_finished
signal pause_state(state)

var code: Code = null
var _paused: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_signal("pause_state", _paused)


func _process(_delta: float) -> void:
	if not code:
		return

	if _paused:
		return

	set_process(false)
	yield(step(), "completed")
	set_process(true)


func toggle_pause():
	_paused = not _paused
	emit_signal("pause_state", _paused)


func step():
	yield(code.step(), "completed")
	emit_signal("step_finished")


func reset():
	if get_tree().reload_current_scene() != OK:
		print("Panic: Somehow the current scene cannot be reloaded.")
