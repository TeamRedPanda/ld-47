extends Node

func play_sound(sound: String):
	get_node(sound).play()
