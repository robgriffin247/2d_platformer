extends CanvasLayer

@onready var retry: Button = $Control/Retry

func _ready() -> void:
	retry.pressed.connect(_reload_level)

func _reload_level() -> void:
	GameOver.visible = false
	#PlayerManager.player_spawned = false
	#LevelManager.load_level(LevelManager.current_level, "LevelEntry")
