# Dev Log


## Getting Ready

1. Download and install Godot
1. Download assets
1. Create a new project
1. Create a Playground scene
	- Set root to ``Area2D``
	- Rename root node to ``Playground``
	- Save the scene in the project root

## Create the Player

1. Create Player folder in project root

1. Create the Player scene
	- Change type of the root node to ``CharacterBody2D``
	- Rename the root node to ``Player``
	- Save the scene

1. Add a ``Sprite2D`` node as a child of Player
	- In the inspector, set *texture* to *new ImageTexture*
	- Drag in relevant spritesheet
	- In the inspector, set *animation* > *Hframes* and *Vframes* to 8 and *frame* to 0
	- Position ``Sprite`` with feet on y=0 (*transform* > *y: -12*)
1. *Project settings* > *Rendering* > *Textures* > *Default Texture Filter*; set to *Nearest*

1. Add a ``CollisionShape2D`` node as a child of ``Player``
	- Set *shape* to *capsule* and resize/position (*radius: 5*, *height: 14*, *position* > *y: -7*)

1. Add a script to the ``Player`` node, using the *Basic Movement* template
	- Add ``class_name Player extends CharacterBody2D`` at the top
	- Adjust ``SPEED`` to ``100.0`` and ``JUMP_VELOCITY`` to ``-300.0``
	- Change ``ui_accept``, ``ui_left`` and ``ui_right`` to ``jump``, ``left`` and ``right`` respectively
	- *Project Settings* > *Input Map* > *Add New Action* (give the name, press *add*) > *Add input* (*Add*, define, *ok*); repeat for jump, left and right
	
1. Add an ``AnimationPlayer`` node to ``Player``
	- Create an idle animation
	- Set to autoplay and loop
	- Set snap to 0.1 and duration to 0.4 seconds
	- Key the frame of the Sprite2D in the Animation Panel and repeat for frames 0 to 3
1. Add run and jump animations
1. Update the player.gd script to call the animations
	```
	extends CharacterBody2D

	@onready var animation_player: AnimationPlayer = $AnimationPlayer
	@onready var sprite: Sprite2D = $Sprite2D

	const SPEED = 120.0
	const JUMP_VELOCITY = -300.0

	func _physics_process(delta: float) -> void:
		# Appy gravity
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Make player jump
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get direction and define left/right movement velocity
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
	```
1. Add the ``Player`` scene to the ``Playground`` scene and position inside viewport
1. Add a ``Camera2D`` node to the ``Playground``
	- Set *Zoom* to *4:4*
	- Position the camera over ``Player``
1. *Project settings* > *Display* > *Window* > *Strech* > *Mode* > *Viewport*
1. Run the game (press *F5*) setting ``Playground`` as the main scene; the player should fall off the screen as the player collision shape has nothing to collide with (``is_on_floor`` is never ``true``)
1. Add a ``StaticBody2D``, with a ``CollisionShape2D`` as a child, to the ``Playground`` scene
	- Rename ``StaticBody2D`` to ``TemporaryBoundary``
	- Set the *shape* to a *WorldBoundaryShape2D*
	- Position just below ``Player``
	- Run the game; the player should no longer fall off the screen as the player collision shape has something to collide with



## Create a Level

1. Create a folder called Worldbuilding in project root
1. Create a WorldTiles scene;
	- Set root node as TileMapLayer
	- Rename to WorldTiles
	- Add a new TileSet (check tile shape and size is 16x16 square)
	- Drag tileset png into Tileset pane
	- Adjust the selection of tiles if needed
	- Add a physics layer
	- Paint the tiles that should be collidable
1. Create a Levels folder in project root
1. Create a Level01 scene
	- Type: Node2D
	- Name: Level01
	- Save in Area01/Level01
1. Add Tiles
	- Add the WorldTiles scene
	- Rename to Background
	- Duplicate twice and rename to Mid- and Foreground
	- Set Ordering > Z-index of foreground to 100
	- Build a level by placing tiles in each layer
	- Save the level
1. Add Level01 to the Playground
	- Delete the TemporaryBoundary and the Camera2D
	- Add a Camera2D node to the Player, setting zoom to 4 and positioning nicely over the Player
	- Add position smoothing to the Camera2D
	- Reposition the Player node in the Playground so transform is 0,0
	- Run game

## Add Level Transitions	



## Add Dying and Game Over


## Add Pickups

## Add HUD

## Add Enemies

## Add Music
