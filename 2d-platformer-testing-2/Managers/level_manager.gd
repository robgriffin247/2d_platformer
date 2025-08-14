extends Node

signal level_loading
signal level_loaded

var current_level: String = ""
var portal: String

func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()

func load_level(level_path: String, new_portal: String) -> void:
	get_tree().paused = true
	await get_tree().process_frame
	portal = new_portal
	await get_tree().process_frame
	level_loading.emit()
	await get_tree().process_frame
	get_tree().change_scene_to_file(level_path)
	await get_tree().process_frame
	get_tree().paused = false
	await get_tree().process_frame
	level_loaded.emit()
