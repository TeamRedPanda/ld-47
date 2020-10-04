class_name BaseLevel
extends Node

enum ObjectType {Robot, Solid, Movable, Goal}

var _code: Code = null
var _goals = []
var _objects = []
var _robot: Robot = null


func execute_code():
	if not _code:
		print("Panic: Trying to call execute_call without a code object.")

	while true:
		yield(_code.execute_and_advance(_robot), "completed")


func instance_objects(map: TileMap, scenes: ObjectScenes):
	var cells = map.get_used_cells()
	for cell in cells:
		var cell_id := int(map.get_cell_autotile_coord(cell.x, cell.y).x)
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

	map.hide()



func get_goals(map: TileMap):
	_goals = map.get_used_cells()
