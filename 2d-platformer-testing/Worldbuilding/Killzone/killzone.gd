class_name Killzone extends Area2D



func _ready() -> void:
	body_entered.connect(_player_entered)
	

func _player_entered(_player: Node2D) -> void:
	await get_tree().create_timer(1.0).timeout
	GameOver.visible = true
	PlayerManager.player_spawned = false
	LevelManager.load_level(LevelManager.current_level, "LevelEntry")
