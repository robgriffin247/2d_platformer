# Dev Log


## Getting Ready

1. Download and install Godot
1. Download assets
1. Create a new project
1. Add assets folder to project root (rename if needed)
1. Create a Playground scene
	- Set root to ``Node2D``
	- Rename root node to ``Playground``
	- Save the scene in the project root
1. Run the game and set current scene as main

## Create the Player

1. Create Player folder in project root

1. Create the Player scene
	- Change type of the root node to ``CharacterBody2D``
	- Rename the root node to ``Player``
	- Save the scene

1. Add a ``Sprite2D`` node as a child of Player
	- Drag in relevant spritesheet to Texture in inspector
	- In the inspector, set *animation* > *Hframes* and *Vframes* to 8 and *frame* to 0
	- Position ``Sprite`` with feet on y=0 (*transform* > *y: -12*)

1. *Project settings* > *Rendering* > *Textures* > *Default Texture Filter*; set to *Nearest*

1. Add a ``CollisionShape2D`` node as a child of ``Player``
	- Set *shape* to *capsule* and resize/position (*radius: 5*, *height: 14*, *position* > *y: -7*)

1. Add a script to the ``Player`` node, using the *Basic Movement* template
	- Add ``class_name Player extends CharacterBody2D`` at the top
	- Adjust ``SPEED`` to ``100.0`` and ``JUMP_VELOCITY`` to ``-305.0``
	- Change ``ui_accept``, ``ui_left`` and ``ui_right`` to ``jump``, ``left`` and ``right`` respectively
	- *Project Settings* > *Input Map* > *Add New Action* (give the name, press *add*) > *Add input* (*Add*, define, *ok*); repeat for jump, left and right
	
1. Add an ``AnimationPlayer`` node to ``Player``
	- Create an idle animation
	- Set to autoplay and loop
	- Set snap to 0.1 and duration to 0.4 seconds
	- Key the frame of the Sprite2D in the Animation Panel and repeat for frames 0 to 3
1. Add run and jump animations (16-19 and 40-47; loop but not autoplay)

1. Update the player.gd script to call the animations (create ref to animationplayer and sprite and add flip of sprite)
	```
	class_name Player extends CharacterBody2D

	@onready var animation_player: AnimationPlayer = $AnimationPlayer
	@onready var sprite: Sprite2D = $Sprite2D

	const SPEED = 100.0
	const JUMP_VELOCITY = -305.0

	func _physics_process(delta: float) -> void:
		# Add gravity
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
	- Delete the TemporaryBoundary and the Camera2D
	- Add a Camera2D node to the Player, setting zoom to 4 and positioning nicely over the Player

#### Optional: PlayerStateMachine

See ``./Player/PlayerStateMachine/README.md``

## Create a Level

1. Create a folder called Worldbuilding in project root
1. Create a WorldTileset scene;
	- Set root node as TileMapLayer
	- Rename to WorldTileset
	- Add a new TileSet (check tile shape and size is 16x16 square)
	- Drag tileset png into Tileset pane
	- Adjust the selection of tiles if needed
	- Add a physics layer
	- Paint the tiles that should be collidable
	- Save scene
1. Create a Worlds folder in project root
1. Create a LevelTemplate scene
	- Type: Node2D
	- Name: LevelTemplate
	- Save in Worlds
1. Add Tiles
	- Add the WorldTileset scene
	- Rename to Background
	- Duplicate twice and rename to Mid- and Foreground
	- Set Ordering > Z-index of foreground to 100
1. Create a level by duplicating the template
	- Build a level by placing tiles in each layer
	- Save the level as Worlds/MyFirstWorld/Level01
1. Add Level01 to the Playground
	- Reposition the Player node in the Playground so transform is 0,0
	- Run game

1. Create a platform folder and scene
	- Root: AnimatableBody2D
	- Add a Sprite2D and CollisionShape2D
	- Use region on platform sprite accordingly
	- Enable one-way collision
	- Add platforms to level
	- Change player z index to 10 (so jumps in front of platforms)

1. Make moving platforms
	- Add platforms to the level
	- Add an AnimationPlayer to the platform node
	- Add an animation called move
	- Key the transform positions appropriately
	- Add autoplay and looping (ping-pong)


### Dying

Aim: When the player dies, a game over screen will appear and player can retry the level by click of a button

- LevelManager will track which level is being played and handle loading of levels
- GameOver scene will provide the UI
- Labels and buttons will be made to be standardised in the game
- Killzone scene will detect when a player enters an area that kills them

1. Add a LevelManager script to Managers folder and autoload
	- Add load_level() function and current_level variable
		```extends Node

		var current_level: String = ""

		func load_level(level_path: String) -> void:
			get_tree().change_scene_to_file(level_path)
		```

1. Add a level script to level(s)
	- update current_level on ready()
		```
		class_name Level extends Node2D

		func _ready() -> void:
			LevelManager.current_level = get_tree().current_scene.scene_file_path
		```

1. Create a GameOver scene in GUI/GameOver
	- Root CanvasLayer
	- Control node as a child
	- Set anchor to full screen
	- Change name
	- Add colorrect to Control, setting anchor to full screen and color

1. Add message
	- Create a scene called label_bold
	- Label at the root
	- Add bold font and set size to 8px
	- Save in General/Labels
	- Repeat for regular font
	- Add a "Game Over" label to the Control node in GameOver scene

1. Add retry button
	- Create scene in General/Buttons called button
	- Add font and set font size
	- Save button scene
	- Add the button scene to the GameOver UI, set text and name node, and position


1. Add GameOver as an autoload
1. Add gameover script, hide the UI on load
	```
	extends CanvasLayer

	@onready var retry_button: Button = $Control/RetryButton

	func _ready() -> void:
		hide()
		retry_button.pressed.connect(_retry)

	func _retry() -> void:
		LevelManager.load_level(LevelManager.current_level)
		hide()
	```

1. Create a killzone scene in worldbuilding/killzone
	- Root area2D
	- Name to Killzone
	- Attach script
	```
	class_name Killzone extends Area2D

	func _ready() -> void:
		body_entered.connect(_player_entered)
		
	func _player_entered(_player: Player) -> void:
		GameOver.show()
	```

Should now be able to play via F5, die and reload the level. However, if user goes to level01 scene, and loads via F6, the player is not loaded to the scene.

## Add a portal

Aim: create a portal which will form the spawn point for each level, allowing removal of the playground and player to be added to levels automatically, and later allow a player to transition from one level to another/to sub-levels (e.g. hidden areas)



## TODO

1. Portal
1. Pickups
1. PauseMenu

<!--



## Add Level Transitions	

Note: including player spawner; not necessary but allows player to be spawned in a level more easily when testing levels etc. and some of the code is needed for scene transitions etc.

1. Add PlayerManager as an autoload
	```
	extends Node

	const PLAYER = preload("res://Player/player.tscn")

	var player : CharacterBody2D
	var player_spawned : bool = false


	func _ready() -> void:
		add_player_instance()
		await get_tree().create_timer(0.1).timeout
		player_spawned = true


	func add_player_instance() -> void:
		player = PLAYER.instantiate()
		add_child(player)


	func set_player_position(_new_position: Vector2) -> void:
		player.global_position = _new_position
		player_spawned = true


	func set_as_parent(_parent: Node2D) -> void:
		if player.get_parent():
			player.get_parent().remove_child(player)
		_parent.add_child(player)


	func unparent_player(_parent: Node2D) -> void:
		_parent.remove_child(player)

	```

1. In Worldbuilding folder, add a PlayerSpawner scene 
	- with a Node2D root
	- copy-paste the Player.sprite into it
	- modulate to change color for easier use
	- add player_spawner script

1. Add level script
	```
	class_name Level extends Node2D


	func _ready() -> void:
		PlayerManager.set_as_parent(self)
		LevelManager.level_load_started.connect(free_level)


	func free_level() -> void:
		PlayerManager.unparent_player(self)
		queue_free()
	```

1. Create a LevelPortal scene
	- Area2D node (rename to LevelPortal)
	- Area: monitoring but not monitorable, and no collision layer, but mask on player level
	- Add a LevelPortal script to the root
		```
		class_name LevelPortal extends Area2D

	@export_category("Portal Destination")
	@export_file("*.tscn") var level
	@export var portal : String = "LevelPortal"

	func _ready() -> void:
		monitoring = false
		_place_player()
		await LevelManager.level_load_completed
		monitoring = true
		body_entered.connect(_player_entered)
		


	func _place_player() -> void:
		if name != LevelManager.target_transition:
			return
		
		PlayerManager.set_player_position(global_position)


	func _player_entered(_player: Node2D) -> void:
		LevelManager.change_level(level, portal)
		

		```
	- Add LevelPortal to the levels
	- Add a levelportal to the PlayerSpawner; no sprite or collisionshape
	- Add suitable sprites and collisionshapes to portals in the levels; 
		- offset sprites/collisionshapes from portal point:
			- LevelPortal should be on the point where the player will enter
			- Sprite & CollisionShape where player will exit via this portal
		- Not having a sprite will make it invisible
		- Not having a shape will make it only function as an entry point
	- Hook up portals to the right levels and portals
	- Add a LevelManager autoload
		```
		extends Node

	signal level_load_started
	signal level_load_completed

	var target_transition: String


	func _ready() -> void:
		await get_tree().process_frame
		level_load_completed.emit()


	func change_level(level_path: String, _target_transition: String) -> void:
		
		# Allow player to complete animation/movement before pausing
		await get_tree().create_timer(0.15).timeout
		
		get_tree().paused = true
		target_transition = _target_transition
		await SceneTransition.fade_out()
		level_load_started.emit()
		await get_tree().process_frame
		get_tree().change_scene_to_file(level_path)
		await SceneTransition.fade_in()
		get_tree().paused = false
		await get_tree().process_frame
		level_load_completed.emit()
		```
1. Add a transition effect
	- Add ./GUI/scene_transition
	- Add scene_transition scene and script files (attach script)
	- Set root to CanvasLayer node
	- Add a Control as child
	- Anchor preset to full rect
	- Add ColorRect as child of Control
	- Set color (black)
	- Add AnimationPlayer as a child of control
	- Default anim to to alpha = 0 and Autoplay
	- Add anims for fade_in and fade_out, keying alpha as appropriate
	- Add code for fade_in and fade_out functions

1. Delete the Playground scene from folder and set main scene in project settings to level01.tscn

## Add Dying and Game Over

1. Create a new scene
1. Root area2d
1. Add script
1. Add _on_body_entered()
1. Add to level, add collisionshape in level

### ADD CAMERA LIMITS

## Add Pickups

## Add HUD

## Add Enemies

## Add Music


## ADD PLATFORMS
 --> 