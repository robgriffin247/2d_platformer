class_name Level extends Node2D

func _ready() -> void:
	PlayerManager.set_as_parent(self)
	LevelManager.level_loading.connect(free_level)
	LevelManager.current_level = get_tree().current_scene.scene_file_path

func free_level() -> void:
	PlayerManager.unparent_player(self)
	queue_free()
