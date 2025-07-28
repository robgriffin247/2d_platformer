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

#### Player: sprite

1. Add an animated ``AnimatedSprite2D`` as a child of ``Player`` root node
1. Add a sprite
    - Select the ``AnimatedSprite2D`` node
    - Go to *Animation* in the inspector pane
    - Click on ``<empty>`` on Sprite Frames, and select *New SpriteFrames*
    - In SpriteFrames in the bottom pane, *add frames from sprite sheet*
    - Add the knight.png file (save this to ``./Player/knight.png``)
    - Adjust horizontal and vertical to 8 frames
    - Select the four idle frames and click *Add 4 frames*
1. Set up the sprite
    - Enable autoplay on load
    - Set the fps to 10
    - Go to *Project* > *Project Settings* > *Rendering* > *Textures* and set *Default Texture Filter* to *Nearest*
    - With the ``AnimatedSprite2D`` selected, set transform.y to -12 px

#### Player: collisions & movement

1. Add a collision shape
    - Add a ``CollisionShape2D`` node to the root
    - Set 
        - shape to *CapsuleShape2D*
        - radius to 6 px
        - height to 16 px 
        - transform.y to -8 px
1. Attach a new script to root ``Player`` node
    - Use the *CharacterBody2D: Basic Movement* template
    - Update ``ui_accept`` to ``up``, ``ui_left`` to ``left`` and ``ui_right`` to right
    - Open the Project Settings and add jump, left and right to the input map
1. Save the player scene
1. In the playground scene, drag the player scene on to the root ``Playground`` node
    - Position the player somewhere inside the purple (viewport) box
1. Add a camera to the ``Player`` root node
    - Set the position and zoom
    - Enable position smoothing
    - Set the bottom limit to 60 (or something reasonable; will later make this dynamic)
1. Run the project (*F5*); the player should fall into nothingness


### World Building

##### World Building: TileMap

1. Create a new reusable terrain scene
    - Use a TileMapLayer as the root node
    - Call the root node ``Terrain``
    - Save the scene in ``./World/terrain.tscn``

1. Add a tileset; this resource will be reused to create levels
    - In the inspector, add a new tileset by clicking on ``<empty>`` > *New TileSet* 
    - In the bottom panel, select TileSet and drag the world_tileset.png file into the dark box in the panel
    - Automatically create the tiles
    - Adjust the selection for the top of the tree
    - Save the scene


##### World Building: Basic Level 

1. Add a level
    - Create a new 2D scene, called ``Level01``
    - Save as ``./World/Area01/level01.tscn``

1. Build your world
    - Add a Node2D as a child, called ``Terrain``; this is just to keep it tidy
    - Add the terrain scene as a child of ``Terrain`` three times, naming them ``Background``, ``Midground`` and ``Foreground``
    - Set the ordering > z-index to 100 on the foreground
    - Draw some tiles to create a very basic world

1. Add the level as a child of the playground scene and adjust the position to suit relative to the player

1. In the terrain scene:
    - select the root node
    - click on the tileset in the inspector panel
    - under physics layers, click *add element*
    - in TileSet in the bottom panel, go to *Paint* and select physics layer 0 as the property to edit
    - paint tiles accordingly; this creates a solid surface that the player cannot pass through

1. Test the game


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