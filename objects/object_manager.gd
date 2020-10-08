class_name ObjectManager
extends TileMap

enum ObjectType {Empty = -1, Robot, Solid, Movable, Goal, Walkable}

var robot: Robot = null
var _objects = []
var starter_cells = []
var goals = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	starter_cells = get_used_cells()
	instance_objects(self, $Scenes)

	var walls := get_node('../Walls') as TileMap
	for cell in get_used_cells():
		walls.set_cellv(cell, 1) # Set this cell

		# Set adjacent cells
		walls.set_cellv(cell + Vector2(-1, -1), 1)
		walls.set_cellv(cell + Vector2(-1, 0), 1)
		walls.set_cellv(cell + Vector2(-1, +1), 1)
		walls.set_cellv(cell + Vector2(0, -1), 1)
		walls.set_cellv(cell + Vector2(0, +1), 1)
		walls.set_cellv(cell + Vector2(+1, -1), 1)
		walls.set_cellv(cell + Vector2(+1, 0), 1)
		walls.set_cellv(cell + Vector2(+1, +1), 1)

	walls.update_bitmask_region()

	assert(len(goals) > 0, "This scene contains no goals.")


func is_empty(pos: Vector2) -> bool:
	#var map := $Map as TileMap
	var cell_id := get_cellv(pos)
	return cell_id == -1


func move_obj(from: Vector2, to: Vector2):
	for obj in _objects:
		if self.world_to_map(obj.position) == from:
			obj.move(to - from)

			self.set_cellv(from, ObjectType.Empty)
			self.set_cellv(to, ObjectType.Movable)


func interact(world_position: Vector2, click_type: int):
	var grid_pos = self.world_to_map(world_position)
	var cell_type = self.get_cellv(grid_pos)

	if cell_type == ObjectType.Robot:
		robot.turn(-1 if click_type == BUTTON_LEFT else 1)
		return

	if cell_type == ObjectType.Walkable && click_type == BUTTON_LEFT:
		self.set_cellv(grid_pos, ObjectType.Solid)
		var obj = $Scenes.solid_object_scene.instance()
		obj.position = self.map_to_world(grid_pos) + self.cell_size / 2
		_objects.push_back(obj)
		get_parent().add_child(obj)
		return

	if cell_type == ObjectType.Solid && click_type == BUTTON_RIGHT:
		if not grid_pos in starter_cells:
			self.set_cellv(grid_pos, ObjectType.Walkable)
			for obj in _objects:
				if self.world_to_map(obj.position) == grid_pos:
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
			ObjectType.Goal:
				scene_to_instance = scenes.goal_object_scene
				goals.push_back(cell)
			ObjectType.Walkable:
				starter_cells.erase(cell)
			_:
				print("Panic: Invalid object at position %s, id %s" %
					[cell, cell_id])

		if not scene_to_instance:
			continue

		var obj = scene_to_instance.instance()
		obj.position = cell_position
		get_parent().call_deferred('add_child', obj)

		if cell_id == ObjectType.Robot:
			robot = obj
			robot.level = get_parent()

		if cell_id == ObjectType.Movable:
			_objects.push_back(obj)

	self.hide()
