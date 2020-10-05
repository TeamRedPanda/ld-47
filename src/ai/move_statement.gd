class_name MoveStatement
extends Statement

var _amount: int = 0
var _current_amount: int = 0

func _init(amount: int):
	_amount = amount
	_current_amount = amount


func _execute(actor: Robot) -> bool:
	actor.move(1)
	_current_amount -= 1

	if _current_amount == 0:
		_current_amount = _amount
		return true
	else:
		return false
