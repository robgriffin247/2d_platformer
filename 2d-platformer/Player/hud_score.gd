extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_coins()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# replace this with a signal on coin pickup
	update_coins()


func update_coins() -> void:
	text = "x" + str(GameManager.coins)
