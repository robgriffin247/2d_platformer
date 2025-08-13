class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 90.0
const JUMP_VELOCITY = -305.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Play right animation
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			animation_player.play("jump")
		if not Input.is_action_just_pressed("jump"):
			if direction != 0 :
				animation_player.play("run")
			if direction == 0:
				animation_player.play("idle")

	# Flip sprite depending on direction
	if direction == -1.0:
		sprite.scale.x = -1
	if direction == 1.0:
		sprite.scale.x = 1
				

	move_and_slide()
