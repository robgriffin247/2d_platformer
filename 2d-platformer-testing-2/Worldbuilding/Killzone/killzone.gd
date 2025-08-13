class_name Killzone extends Area2D

func _ready() -> void:
	body_entered.connect(_player_entered)
	
func _player_entered(_player: Player) -> void:
	GameOver.show()
