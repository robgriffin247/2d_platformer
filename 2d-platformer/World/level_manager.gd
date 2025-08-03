extends Node


signal level_load_started
signal level_load_complete


var target_transition_area: String

func _ready() -> void:
	await get_tree().process_frame
	level_load_complete.emit()

func load_new_level(
	level_path: String,
	_target_transition_area: String
) -> void:
	
	get_tree().paused = true
	target_transition_area = _target_transition_area
	
	level_load_started.emit()
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file(level_path)
	
	await get_tree().process_frame
	
	level_load_complete.emit()
