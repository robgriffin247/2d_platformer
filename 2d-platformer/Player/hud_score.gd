extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = GameManager.get_coin_count_string()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# replace this with a signal on coin pickup
	text = GameManager.get_coin_count_string()
