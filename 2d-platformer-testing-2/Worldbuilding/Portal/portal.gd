class_name Portal extends Area2D

@export_category("Destination")
@export_file("*.tscn") var level
@export var portal: String = "Portal"
@export_enum("Left", "Centre", "Right") var exit_position = "Centre"

@export_category("Properties")
@export var sprite : bool = true
@export var collision_shape : bool = true

@onready var sprite_2d: Sprite2D = $DefaultSprite2D
@onready var collision_shape_2d: CollisionShape2D = $DefaultCollisionShape2D

func _ready() -> void:
	
	collision_shape_2d.disabled = !collision_shape
	sprite_2d.visible = sprite
	
	monitoring = false
	
	_place_player()
	
	await LevelManager.level_loaded
	
	if level==null:
		level = LevelManager.current_level
		
	
	monitoring = true
	
	body_entered.connect(_player_entered)


func _place_player() -> void:
	
	if name != LevelManager.portal and name!="Portal":
		return

	var x_offset : float = 0.0
	
	if exit_position=="Left":
		x_offset = -16.0
	elif exit_position=="Right":
		x_offset = 16.0	
	
	PlayerManager.set_player_position(global_position + Vector2(x_offset,0))
	PlayerManager.player.sprite.scale.x = -1 if exit_position == "Left" else 1

func _player_entered(_player: Player):
	LevelManager.load_level(level, portal)
