class_name Statement

signal executed

func _execute(_actor: Robot) -> bool:
	return true


func execute(actor: Robot):
	var should_advance = _execute(actor)

	yield(actor, "command_executed")
	emit_signal("executed", should_advance)
