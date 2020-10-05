extends Label

func show_statement(stmt: TurnStatement):
	if stmt._amount < 0:
		text = "Turn counterclock %s times" %stmt._amount
	else:
		text = "Turn clockwise %s times" %stmt._amount		
