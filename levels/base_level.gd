class_name BaseLevel
extends Node

enum ObjectType {Empty = -1, Robot, Solid, Movable, Goal}

var _code: Code = null
var _goals = []

var _paused: bool = false


func _ready() -> void:
	$Collision.hide()


func execute_code():
	if not _code:
		print("Panic: Trying to call execute_call without a code object.")

	_paused = false

	while not _paused:
		yield(step(), "completed")


func toggle_pause():
	_paused = not _paused


func step():
	yield(_code.step($Objects.robot), "completed")


func reset():
	if get_tree().reload_current_scene() != OK:
		print("Panic: Somehow the current scene cannot be reloaded.")


func get_goals(map: TileMap):
	_goals = map.get_used_cells()


func move(from:Vector2, direction: Vector2) -> bool:
	var object_map := get_node("Objects") as TileMap

	from = object_map.world_to_map(from)
	direction = Vector2(int(direction.x), int(direction.y))
	var to := from + direction

	if is_wall(to):
		return false

	if is_solid(to):
		return false

	if is_movable(to):
		var behind_pos = to + direction
		if is_wall(behind_pos) or is_solid(behind_pos) or is_movable(behind_pos):
			return false

		$Objects.move_obj(to, direction)



	object_map.set_cellv(from, ObjectType.Empty)
	object_map.set_cellv(to, ObjectType.Robot)

	return true


func is_wall(position: Vector2) -> bool:
	var wall_map := get_node("Collision") as TileMap
	var cell_id := wall_map.get_cellv(position)

	if cell_id == -1:
		return false

	return true


func is_solid(position: Vector2) -> bool:
	var object_map := get_node("Objects") as TileMap
	var cell_type := object_map.get_cellv(position)

	return cell_type == ObjectType.Solid


func is_movable(position: Vector2) -> bool:
	var object_map := get_node("Objects") as TileMap
	var cell_type := object_map.get_cellv(position)

	return cell_type == ObjectType.Movable
