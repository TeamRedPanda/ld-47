class_name TurnStatement
extends Statement

var _amount: int = 0


func _init(amount: int):
	_amount = amount


func _execute(actor: Robot) -> bool:
	actor.turn(_amount)
	return true
