class_name BaseLevel
extends Node2D

enum ObjectType {Empty = -1, Robot, Solid, Movable, Goal}

signal cleared
signal restart

var _goals = []

onready var _code_runner: CodeRunner = $"Code runner"
onready var _instruction_list: VBoxContainer = $"Code View/Instruction list"


func register_code(code: Code):
	code.actor = $Objects.robot
	_code_runner.code = code
	_code_runner.connect("step_finished", self, "check_win")
	_instruction_list.set_code(code)


func check_win():
	for goal in _goals:
		if not is_movable(goal):
			return

	_code_runner._paused = true
	_code_runner.disconnect("step_finished", self, "check_win")
	SoundController.play_sound("Clear Level Sound")
	emit_signal("cleared")


func get_goals(map: TileMap):
	_goals = map.get_used_cells()


func _input(event: InputEvent) -> void:
	var mouseClick = event as InputEventMouseButton
	if not mouseClick:
		return

	if not mouseClick.pressed:
		return

	if not _code_runner.started and is_interactable(mouseClick.position):
		$Objects.interact(mouseClick.position, mouseClick.button_index)


func is_interactable(position: Vector2) -> bool:
	var walls := $Walls as TileMap

	if walls.get_cellv(walls.world_to_map(position)) == ObjectType.Empty:
		return false

	return not is_wall(position)


func move(from:Vector2, direction: Vector2) -> bool:
	var object_map := $Objects as TileMap

	from = object_map.world_to_map(from)
	direction = Vector2(int(direction.x), int(direction.y))
	var to := from + direction

	if is_wall(to):
		return false

	if is_solid(to):
		return false

	if is_movable(to):
		var pushed = try_push_movable(to, direction)
		if not pushed:
			return false

	object_map.set_cellv(from, ObjectType.Empty)
	object_map.set_cellv(to, ObjectType.Robot)

	return true


func try_push_movable(from, towards):
	var behind_pos = from + towards
	if is_wall(behind_pos) or is_solid(behind_pos) or is_movable(behind_pos):
		return false

	$Objects.move_obj(from, behind_pos)
	return true

func is_wall(position: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	var wall_map := $Walls as TileMap
	var point = wall_map.map_to_world(position) + wall_map.cell_size / 2

	return len(space_state.intersect_point(point)) > 0


func is_solid(position: Vector2) -> bool:
	var object_map := $Objects as TileMap
	var cell_type := object_map.get_cellv(position)

	return cell_type == ObjectType.Solid


func is_movable(position: Vector2) -> bool:
	var object_map := $Objects as TileMap
	var cell_type := object_map.get_cellv(position)

	return cell_type == ObjectType.Movable


func restart() -> void:
	emit_signal("restart")
