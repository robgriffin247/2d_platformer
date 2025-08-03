extends Node

const PLAYER = preload("res://Player/player.tscn")

var is_alive : bool = true
var player: Player
var player_spawned = false

func ready():
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true


func add_player_instance():
	player = PLAYER.instantiate()
	add_child(player)


func set_as_parent(_p: Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_p.add_child(player)


func unparent_player(_p: Node2D) -> void:
	_p.remove_child(player)
	

func set_player_position(_new_pos: Vector2) -> void:
	player.global_position = _new_pos

func die():
	is_alive = false
	await get_tree().create_timer(1.6).timeout
	GameOver.visible = true
	Hud.visible = false

func respawn():	
	is_alive = true
	GameManager.coins = 0
	get_tree().reload_current_scene()
	GameOver.visible = false
	Hud.visible = true
	
