# 2D Platformer

The aim of this project is to create a 2D platformer game, inspired by the Brackeys Godot tutorial on YouTube.
Before starting, [download](https://godotengine.org/) and install the Godot Engine.


### Create the Project

1. Open the Godot Engine
1. Create a new project
    - Click *Create* in the Project Manager
    - Give the project a name
    - Click *Create & Edit*
1. Create a root node
    - In the Scene pane, under *Create Root Node*, click *2D Scene*
    - Rename the new ``Node2D`` as ``Playground``
    - Save the scene as ``./playground.tscn``
1. Run the game
    - Play button or *F5*
    - You may be asked to set a main scene, choose *Select Current*


### Add a player

#### Player: root scene

1. Create a new 2D scene
    - Change the type to ``CharacterBody2D``
    - Rename it as ``Player``
    - Save it as ``./Player/player.tscn``


1. Add a ``Sprite2D`` to ``Player``
    - Add sprite by dragging png in to inspector
    - Set Animation Hframes/Vframes appriopriately (8x7)
    - Move sprite so feet are on y=0 (transform.y=-10)
    - In Project Settings, set Rendering > Textures > Default Texture Filter to Nearest (if using pixel art)

1. Add a ``CollisionShape2D`` to ``Player``
    - Select a suitable shape (rectangle)
    - Position and size accordingly (8x14, transform.y=-7)

1. Add an ``AnimationPlayer`` to ``Player``
    - Create a new animation called ``idle``
    - Turn on autoplay and looping
    - Set animation length to 0.4s and snap to 0.1
    - Key the sprite frame 0 at 0.0 and repeat for frames 1, 2, 3

1. Add a script to the player, using the basic movement template
    - Set ``class_name Player extends CharacterBody2d``
    - Update ``ui_accept`` to ``up``, ``ui_left`` to ``left`` and ``ui_right`` to ``right``
    - Add jump, left and right key inputs in project settings input map

1. Add the Player scene to ``Playground``
    - Run the game; player will fall and camera is very zoomed out
    - In project settings, set viewport width and height to 420 x 270 and stretch mode to viewport (will scale game to screen size)
    - Add an StaticBody2D to Playground, add a CollisionShape2D to the StaticBody2D, and a WorldBoundary shape
    - Add a Camera to the playground, setting zoom to 4 and enable position smoothing
    - Position the player, StaticBody2D and camera as needed
    - Run the game
    - Cut and paste the camera (positioning correctly) into the Player scene
    - Delete the Area2D from Playground and save

    
### World Building

##### World Building: TileMap

1. Create a new reusable terrain scene
    - Use a TileMapLayer as the root node
    - Call the root node ``WorldTileset``
    - Save the scene in ``./Worldbuilding/Tilesets/world_tileset.tscn``

1. Add a tileset; this resource will be reused to create levels
    - In the inspector, add a new tileset by clicking on ``<empty>`` > *New TileSet* 
    - In the bottom panel, select TileSet and drag the world_tileset.png file into the dark box in the panel
    - Automatically create the tiles
    - Adjust the selection for the top of the tree
    - Save the scene
    - Create a new 2D scene, called ``LevelTemplate``
    - Save as ``./Worlds/level_template.tscn``
    - Add a Node2D as a child, called ``Tilesets``; this is just to keep it tidy
    - Add the WorldTileset scene as a child of ``Tilesets`` three times, naming them ``Background``, ``Midground`` and ``Foreground``
    - Set the ordering > z-index to 100 on the foreground


##### World Building: Basic Level 

1. Create a level
    - Duplicate template to Worlds/World01/level_01.tscn
    - Draw some tiles to create a very basic world
    - Add the level to the playground
    - Reposition the player
    - Run the game; player falls through


1. In the world_tileset scene:
    - select the root node
    - click on the tileset in the inspector panel
    - under physics layers, click *add element*
    - in TileSet in the bottom panel, go to *Paint* and select physics layer 0 as the property to edit
    - paint tiles accordingly; this creates a solid surface that the player cannot pass through

1. Test the game; player should now land on terrain






#### World Building: Moving Platforms

1. Create a ``Platform`` scene
    - Use an ``AnimatableBody2D``
    - Rename to ``Platform``
    - Save as ``./World/Platforms/platform.tscn``
1. Add a ``Sprite2D`` as a child
    - Add the ``platforms.png`` file to the sprite
    - Adjust region to match the chosen platform (use pixel snap)
1. Add a ``CollisionShape2D`` to suit the platform
    - Enable One-way collision
1. Save the scene and add to the Level scene as needed
1. Add movement
    - Add an ``AnimationPlayer`` as a child of the ``Platform``
    - Create a new animation
    - Key the transform x/y properties in the animation
    - Set the animation to loop and autoplay


### Pickups

1. Create a coin
    - Create a new scene
    - Set root node as an ``Area2D``
    - Rename the node to ``Coin``
    - Save as ``./World/Pickups/Coin/coin.tscn``
1. Add and adjust appropriate ``AnimatedSprite2D`` and ``CollisionShape2D`` nodes
    - Set the ``Coin`` collision mask to layer 2
    - In the player scene, set the collision layer of the ``Player`` node to layer 2
1. Add a game manager & coin script

<!-- TODO cont -->

#### Dying

1. Add a scene called Killzone with an ``Area2D`` at the root
    - Set collision mask to 2 so it detects the player
    - Save the scene as ``./Player/killzone.tscn``
1. Add a script to the killzone scene
    - Connect an ``_on_body_entered`` signal
    - Add a delay using ``get_tree().create_timer(...).timeout``
	- Reload the game using ``get_tree().reload_current_scene()``
1. Within the level scene, add the killzone scene and position a ``CollisionShape2D`` as a child of the killzone, then position suitably


#### Enemies

1. Create a new scene in ``./World/Enemies/slime.tscn``
    - Root node ``Slime`` of type ...
    - Add an ``AnimatedSprite2D`` as a child
    - Add enemy sprites and setup animation
1. Add two ``RayCast2D`` nodes (rename to ``RayCastRight`` and ``RayCastLeft`` and position, resize and rotate suitably)
1. Add a script to the slime root node
    - Add a variable of ``var direction : int = 1``
    - Add the raycasts as onready variables
    - Create a ``_process()`` function
        
        ```
        func _process(delta: float) -> void:
            if ray_cast_right.is_colliding():
                direction = -1
                animated_sprite.flip_h = true
            
            if ray_cast_left.is_colliding():
                direction = 1
                animated_sprite.flip_h = false

            position.x += direction * delta * 60	
        ```