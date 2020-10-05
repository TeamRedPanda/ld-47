extends BaseLevel


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	._ready()

	_code = Code.new()
	_code.add(TurnStatement.new(-1))
	_code.add(MoveStatement.new(3))

	instance_objects($Objects, $"Object Scenes")
	get_goals($Goals)
