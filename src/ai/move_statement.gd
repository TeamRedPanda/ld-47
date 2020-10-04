class_name MoveStatement
extends Statement

var _amount: int = 0


func _init(amount: int):
	_amount = amount


func _execute(actor: Robot):
	actor.move(_amount)
