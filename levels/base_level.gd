class_name BaseLevel
extends Node

enum ObjectType {Empty = -1, Robot, Solid, Movable, Goal}

var _code: Code = null
var _goals = []
var _objects = []
var _robot: Robot = null

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
	yield(_code.step(_robot), "completed")


func reset():
	get_tree().reload_current_scene()


func instance_objects(map: TileMap, scenes: ObjectScenes):
	var cells = map.get_used_cells()
	for cell in cells:
		var cell_id := int(map.get_cellv(cell))
		var cell_position := map.map_to_world(cell) + map.cell_size / 2

		var scene_to_instance = null
		match cell_id:
			ObjectType.Robot:
				scene_to_instance = scenes.robot_scene
			ObjectType.Solid:
				scene_to_instance = scenes.solid_object_scene
			ObjectType.Movable:
				scene_to_instance = scenes.movable_object_scene
			_:
				print("Panic: Invalid object at position %s, id %s" %
					[cell, cell_id])

		if not scene_to_instance:
			continue

		var obj = scene_to_instance.instance()
		obj.position = cell_position
		add_child(obj)

		if cell_id == ObjectType.Robot:
			_robot = obj
			_robot.level = self

		if cell_id == ObjectType.Movable:
			_objects.push_back(obj)

	map.hide()


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

		var world_pos := object_map.map_to_world(to) + object_map.cell_size / 2
		for obj in _objects:
			if object_map.world_to_map(obj.position) == to:
				obj.move(direction)

				object_map.set_cellv(to, ObjectType.Empty)
				object_map.set_cellv(behind_pos, ObjectType.Movable)

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
