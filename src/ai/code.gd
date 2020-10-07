class_name Code
#extends Node

var statements = []
var _current_index := 0

var actor


func add(stmt: Statement):
	statements.push_back(stmt)


func reset():
	_current_index = 0


func ready() -> bool:
	return not actor.is_animating()


func step():
	var stmt = statements[_current_index]
	stmt.execute(actor)

	var should_advance = yield(stmt, "executed")

	if should_advance:
		_current_index = (_current_index + 1) % len(statements)
