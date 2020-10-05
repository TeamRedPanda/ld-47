extends Node2D

export(Array, PackedScene) var levels

var current_level: BaseLevel = null
var current_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level(current_index)


func load_level(index: int):
	var last_level = current_level

	if last_level:
		var final_position = Vector2(-get_viewport().size.x, 0)
		$Tween.interpolate_property(last_level, "position", null, final_position, 1, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
		$Tween.start()

	current_level = levels[index].instance()
	current_level.connect("cleared", self, "on_level_cleared")
	add_child(current_level)

	current_level.position = Vector2(get_viewport().size.x, 0)
	$Tween.interpolate_property(current_level, "position", null, Vector2(0, 0), 1, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	$Tween.start()

	yield($Tween, "tween_all_completed")
	if last_level:
		last_level.queue_free()


func on_level_cleared():
	current_index += 1

	if current_index < len(levels):
		load_level(current_index)

