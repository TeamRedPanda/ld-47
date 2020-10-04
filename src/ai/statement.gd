class_name Statement

signal executed

func _execute(actor: Robot):
	pass


func execute(actor: Robot):
	_execute(actor)
	wait_execution(actor)


func wait_execution(actor: Robot):
	yield(actor, "command_executed")
	emit_signal("executed")
