class_name ObjectManager
extends Node2D

enum ObjectType {Empty = -1, Robot, Solid, Movable, Goal, Placeable}

var robot: Robot = null
var _objects = []
var placeable_cells = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance_objects($Map, $Scenes)


func is_empty(pos: Vector2) -> bool:
	var map := $Map as TileMap
	var cell_id := map.get_cellv(pos)
	return cell_id == -1


func move_obj(from: Vector2, to: Vector2):
	for obj in _objects:
		if $Map.world_to_map(obj.position) == from:
			obj.move(to - from)

			$Map.set_cellv(from, ObjectType.Empty)
			$Map.set_cellv(to, ObjectType.Movable)


func interact(world_position: Vector2, click_type: int):
	var grid_pos = $Map.world_to_map(world_position)
	var cell_type = $Map.get_cellv(grid_pos)

	if cell_type == ObjectType.Robot:
		robot.turn(-1 if click_type == BUTTON_LEFT else 1)
		return

	if cell_type == ObjectType.Placeable && click_type == BUTTON_LEFT:
		$Map.set_cellv(grid_pos, ObjectType.Solid)
		var obj = $Scenes.solid_object_scene.instance()
		obj.position = $Map.map_to_world(grid_pos) + $Map.cell_size / 2
		_objects.push_back(obj)
		add_child(obj)
		return

	if cell_type == ObjectType.Solid && click_type == BUTTON_RIGHT:
		if grid_pos in placeable_cells:
			$Map.set_cellv(grid_pos, ObjectType.Placeable)
			for obj in _objects:
				if $Map.world_to_map(obj.position) == grid_pos:
					obj.queue_free()
					_objects.erase(obj)
					break
			return


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
			ObjectType.Placeable:
				placeable_cells.push_back(cell)
			_:
				print("Panic: Invalid object at position %s, id %s" %
					[cell, cell_id])

		if not scene_to_instance:
			continue

		var obj = scene_to_instance.instance()
		obj.position = cell_position
		add_child(obj)

		if cell_id == ObjectType.Robot:
			robot = obj
			robot.level = get_parent()

		if cell_id == ObjectType.Movable:
			_objects.push_back(obj)

	map.hide()
