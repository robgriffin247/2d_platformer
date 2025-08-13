class_name Level extends Node2D

func _ready() -> void:
	LevelManager.current_level = get_tree().current_scene.scene_file_path
	print(LevelManager.current_level)
