extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -320.0


func _physics_process(delta: float) -> void:
	# Respond to gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Left/Right
	var direction : float = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
