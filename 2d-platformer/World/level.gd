class_name Level extends Node2D


func ready():
	PlayerManager.set_as_parent(self)
	LevelManager.level_load_started.connect(free_level)


func free_level() -> void:
	PlayerManager.unparent_player(self)
	queue_free()
	
