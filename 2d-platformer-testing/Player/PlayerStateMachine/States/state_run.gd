class_name StateRun extends State

@onready var idle: StateIdle = $"../Idle"
@onready var jump: StateJump = $"../Jump"

func enter() -> void:
	player.update_animation("run")


func exit() -> void:
	pass

func process(_delta: float) -> State:

	if player.is_on_floor() and Input.is_action_just_pressed("jump"):
		return jump
	if player.current_direction == 0.0:
		return idle
		
	player.set_direction()
	
	return null
	
func physics(_delta: float) -> State:
	return null

func handle_input(_event: InputEvent) -> State:
	return null
