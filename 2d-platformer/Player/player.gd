class_name Player extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var played_death_anim: bool = false 

const SPEED = 100.0
const JUMP_VELOCITY = -320.0


func _physics_process(delta: float) -> void:
	
	# MOVEMENT
	# Respond to gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor() and PlayerManager.is_alive:
		velocity.y = JUMP_VELOCITY
	
	# Left/Right
	var direction : float = Input.get_axis("left", "right")

	if direction and PlayerManager.is_alive:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	# SPRITE DIRECTION
	if PlayerManager.is_alive:
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
	
	# ANIMATIONS
	if not PlayerManager.is_alive:
		animated_sprite.play("die")
			
	elif is_on_floor():	
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
		if Input.is_action_just_pressed("jump"):
			animated_sprite.play("jump")

	move_and_slide()
