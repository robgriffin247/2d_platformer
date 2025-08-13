extends Node

var current_level: String = ""

func load_level(level_path: String) -> void:
	get_tree().change_scene_to_file(level_path)
