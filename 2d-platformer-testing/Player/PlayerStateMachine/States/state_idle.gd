class_name StateIdle extends State

@onready var run: StateRun = $"../Run"
@onready var jump: StateJump = $"../Jump"

func enter() -> void:
	player.update_animation("idle")


func exit() -> void:
	pass

func process(_delta: float) -> State:

	if player.current_direction != 0:
		if player.is_on_floor() and Input.is_action_just_pressed("jump"):
			return jump
			
		return run
		
	player.velocity.x = move_toward(player.velocity.x, 0, player.SPEED)
	return null
	
func physics(_delta: float) -> State:
	return null

func handle_input(_event: InputEvent) -> State:
	return null
