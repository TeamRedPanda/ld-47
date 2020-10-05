class_name InstructionList
extends VBoxContainer

var code: Code = null

export var move_stmt_view : PackedScene 
export var turn_stmt_view : PackedScene

func set_code(_code: Code):
	code = _code
	
	for stmt in code.statements:
		if stmt is MoveStatement:
			var view = move_stmt_view.instance()
			view.show_statement(stmt)
			add_child(view)
		elif stmt is TurnStatement:
			var view = turn_stmt_view.instance()
			view.show_statement(stmt)
			add_child(view)
