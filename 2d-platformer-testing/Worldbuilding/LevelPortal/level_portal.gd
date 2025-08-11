class_name LevelPortal extends Area2D

@export_category("Portal Destination")
@export_file("*.tscn") var level
@export var portal : String = "LevelPortal"

func _ready() -> void:
	monitoring = false
	_place_player()
	await LevelManager.level_load_completed
	monitoring = true
	body_entered.connect(_player_entered)
	


func _place_player() -> void:
	if name != LevelManager.portal:
		return
	
	PlayerManager.set_player_position(global_position)


func _player_entered(_player: Node2D) -> void:
	LevelManager.load_level(level, portal)
	
