class_name ObjectManager
extends Node

enum ObjectType {Empty = -1, Robot, Solid, Movable, Goal}

var robot: Robot = null
var _objects = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance_objects($Map, $Scenes)


func move_obj(to: Vector2, direction: Vector2):
	var behind_pos = to + direction
	for obj in _objects:
		if $Map.world_to_map(obj.position) == to:
			obj.move(direction)

			$Map.set_cellv(to, ObjectType.Empty)
			$Map.set_cellv(behind_pos, ObjectType.Movable)


func instance_objects(map: TileMap, scenes: ObjectScenes):
	var cells = map.get_used_cells()
	for cell in cells:
		var cell_id := int(map.get_cellv(cell))
		var cell_position := map.map_to_world(cell) + map.cell_size / 2

		var scene_to_instance = null
		print(cell_id)
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
			robot = obj
			robot.level = get_parent()

		if cell_id == ObjectType.Movable:
			_objects.push_back(obj)

	map.hide()