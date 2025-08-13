extends Node

signal level_load_started
signal level_load_completed

var current_level: String = ""
var portal: String

func _ready() -> void:
	await get_tree().process_frame
	level_load_completed.emit()


func load_level(level_path: String, _portal: String) -> void:
	# Allow player to complete animation/movement before pausing
	await get_tree().create_timer(0.15).timeout
	get_tree().paused = true
	portal = _portal
	await SceneTransition.fade_out()
	level_load_started.emit()
	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)
	await SceneTransition.fade_in()
	get_tree().paused = false
	await get_tree().process_frame
	level_load_completed.emit()
