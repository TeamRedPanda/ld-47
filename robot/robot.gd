class_name Robot
extends Node2D

signal command_executed

onready var _tween: Tween = $Tween

const _move_distance: int = 64


# Called when the node enters the scene tree for the first time.
func _process(_delta: float) -> void:
	move(1)


func move(steps: int):
	var final_pos := position + Vector2(1, 0) * steps * _move_distance

	_tween.interpolate_property(self, "position", position, final_pos, 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	_tween.start()

	set_process(false)
	yield(_tween, "tween_completed")
	set_process(true)

	emit_signal("command_executed")
