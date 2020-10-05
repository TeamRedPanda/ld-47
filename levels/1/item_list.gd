extends ItemList

var code: Code = null

func set_code(_code: Code):
	code = _code
	
	for stmt in code.statements:
		print("o.o")
	
