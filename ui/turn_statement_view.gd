extends Label

func show_statement(stmt: TurnStatement):
	text = "Turn %s times" %stmt._amount
