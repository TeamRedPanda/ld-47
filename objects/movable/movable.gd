class_name Movable
extends Node2D

onready var _tween: Tween = $Tween

const _move_distance: int = 64

var level

func move(direction: Vector2):
	var final_pos := position + direction * _move_distance

	_tween.interpolate_property(self, "position", position, final_pos, 0.6, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	_tween.start()
