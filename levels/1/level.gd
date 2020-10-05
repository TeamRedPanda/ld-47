extends BaseLevel


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	._ready()

	var code := Code.new()
	code.add(TurnStatement.new(-1))
	code.add(MoveStatement.new(3))
	register_code(code)

	get_goals($Goals)
