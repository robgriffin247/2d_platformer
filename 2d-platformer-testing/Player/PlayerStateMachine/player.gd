class_name Player extends CharacterBody2D

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var current_direction : float = 0.0
var previous_direction : float = 0.0

const SPEED = 100.0

func _ready() -> void:
	state_machine.initialise(self)
	
func _process(_delta: float) -> void:
	current_direction = Input.get_axis("left", "right")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += (get_gravity() * delta).y
	
	velocity.x = current_direction * SPEED

	move_and_slide()


func set_direction() -> bool:
	if current_direction == 0.0 || current_direction == previous_direction:
		return false
	
	previous_direction = current_direction
	sprite.scale.x = current_direction
	return true


func update_animation(state: String) -> void:
	animation_player.play(state)
