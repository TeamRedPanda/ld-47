class_name Code
#extends Node

var statements = []
var _current_index := 0


func add(stmt: Statement):
	statements.push_back(stmt)


func reset():
	_current_index = 0


func execute_and_advance(actor: Robot):
	var stmt = statements[_current_index]
	stmt.execute(actor)

	_current_index = (_current_index + 1) % len(statements)

	yield(stmt, "executed")
