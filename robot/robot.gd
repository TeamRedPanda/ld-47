class_name Robot
extends Node2D

signal command_executed

onready var _tween: Tween = $Tween

const _move_distance: int = 64
var _look_direction: Vector2 = Vector2(1, 0)

var level


func move(steps: int):
	for _i in range(steps):
		var final_pos := position + _look_direction * _move_distance

		if not level.move(position, _look_direction):
			continue

		_tween.interpolate_property(self, "position", position, final_pos, 0.6, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		_tween.start()

		yield(_tween, "tween_completed")

	yield(get_tree(), "idle_frame")
	emit_signal("command_executed")


func turn(steps: int):
	_look_direction = _look_direction.rotated(PI / 2 * steps)
	_tween.interpolate_property(self, "rotation", null, rotation + PI / 2 * steps, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	_tween.start()

	yield(_tween, "tween_completed")

	emit_signal("command_executed")
