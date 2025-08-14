class_name Killzone extends Area2D

func _ready() -> void:
	await get_tree().create_timer(0.05).timeout # prevents 2nd death on retry
	body_entered.connect(_player_entered)
	
func _player_entered(_player: Player) -> void:
	GameOver.show()
