class_name LevelTransition extends Area2D

@export_file("*.tscn") var level
@export var target_transition_area: String = "LevelTransition"


func _ready() -> void:
	monitoring = false
	_place_player()
	await LevelManager.level_load_complete
	monitoring = true
	body_entered.connect(_player_entered)
	


func _player_entered(_p: Node2D) -> void:
	print("entered")
	LevelManager.load_new_level(level, target_transition_area)


func _place_player() -> void:
	if name != LevelManager.target_transition_area:
		return
	PlayerManager.set_player_position(global_position)
