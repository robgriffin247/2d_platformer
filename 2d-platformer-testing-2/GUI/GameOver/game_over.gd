extends CanvasLayer

@onready var retry_button: Button = $Control/RetryButton

func _ready() -> void:
	hide()
	retry_button.pressed.connect(_retry)

func _retry() -> void:
	LevelManager.load_level(LevelManager.current_level)
	hide()
