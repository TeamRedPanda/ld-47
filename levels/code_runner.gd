class_name CodeRunner
extends Node

signal step_finished
signal pause_state(state)

var code: Code = null
var _paused: bool = true setget set_paused
var _is_executing: bool = false

var action_queue = []
const ACTION_TOLERANCE: int = 300


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_signal("pause_state", _paused)


func _process(_delta: float) -> void:
	if not code:
		return

	run_queued_actions()

	if _paused:
		return

	step()


func run_queued_actions():
	if len(action_queue) == 0:
		return

	if _is_executing:
		return

	match action_queue[0]:
		{'action': 'step', 'time': var time}:
			if time + ACTION_TOLERANCE > OS.get_ticks_msec():
				_paused = true
				step()

	action_queue.remove(0)


func set_paused(paused):
	_paused = paused
	emit_signal("pause_state", _paused)


func toggle_pause():
	self._paused = not _paused


func step():
	_is_executing = true
	set_process(false)

	yield(code.step(), "completed")

	_is_executing = false
	set_process(true)

	emit_signal("step_finished")


func step_once():
	if not _paused:
		self._paused = true

	if _is_executing:
		action_queue.push_back({
			'action': 'step',
			'time': OS.get_ticks_msec()
		})
	else:
		yield(step(), "completed")


func reset():
	if get_tree().reload_current_scene() != OK:
		print("Panic: Somehow the current scene cannot be reloaded.")
