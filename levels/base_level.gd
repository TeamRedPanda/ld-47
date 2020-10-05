class_name BaseLevel
extends Node

enum ObjectType {Empty = -1, Robot, Solid, Movable, Goal}

var _goals = []

onready var _code_runner: CodeRunner = $"Code runner"


func _ready() -> void:
	$Collision.hide()


func register_code(code: Code):
	code.actor = $Objects.robot
	_code_runner.code = code


func get_goals(map: TileMap):
	_goals = map.get_used_cells()


func move(from:Vector2, direction: Vector2) -> bool:
	var object_map := get_node("Objects/Map") as TileMap

	from = object_map.world_to_map(from)
	direction = Vector2(int(direction.x), int(direction.y))
	var to := from + direction

	if is_wall(to):
		return false

	if is_solid(to):
		return false

	if is_movable(to):
		try_push_movable(to, direction)

	object_map.set_cellv(from, ObjectType.Empty)
	object_map.set_cellv(to, ObjectType.Robot)

	return true


func try_push_movable(from, towards):
	var behind_pos = from + towards
	if is_wall(behind_pos) or is_solid(behind_pos) or is_movable(behind_pos):
		return false

	$Objects.move_obj(from, behind_pos)


func is_wall(position: Vector2) -> bool:
	var wall_map := get_node("Collision") as TileMap
	var cell_id := wall_map.get_cellv(position)

	if cell_id == -1:
		return false

	return true


func is_solid(position: Vector2) -> bool:
	var object_map := get_node("Objects/Map") as TileMap
	var cell_type := object_map.get_cellv(position)

	return cell_type == ObjectType.Solid


func is_movable(position: Vector2) -> bool:
	var object_map := get_node("Objects/Map") as TileMap
	var cell_type := object_map.get_cellv(position)

	return cell_type == ObjectType.Movable
