class_name StateJump extends State

const JUMP_VELOCITY = -300.0
@onready var idle: StateIdle = $"../Idle"
@onready var run: StateRun = $"../Run"

func enter() -> void:
	player.update_animation("jump")
	player.velocity.y = JUMP_VELOCITY

func exit() -> void:
	pass

func process(delta: float) -> State:

	if player.current_direction == 0.0 and player.is_on_floor():
		return idle

	if player.current_direction != 0.0 and player.is_on_floor():
		return run
	
	player.set_direction()
	
	return null

	
func physics(_delta: float) -> State:
	return null

func handle_input(_event: InputEvent) -> State:
	return null
