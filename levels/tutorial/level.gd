extends BaseLevel


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	._ready()

	var code := Code.new()
	code.add(MoveStatement.new(3))
	code.add(TurnStatement.new(-2))
	code.add(MoveStatement.new(3))
	code.add(TurnStatement.new(2))

	register_code(code)
