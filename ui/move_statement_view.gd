extends Label

func show_statement(stmt: MoveStatement):
	text = "Move foward %s times" %stmt._amount
