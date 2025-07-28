class_name Killzone extends Node


func _on_body_entered(_body: Node2D) -> void:
	if PlayerManager.is_alive:
		# Remove strikezone to prevent slime also dying
		var i = 0
		for c in get_parent().get_children():
			if c is Strikezone:
				get_parent().get_child(i).queue_free()
			else:
				i += 1
				
		PlayerManager.is_alive = false
		Engine.time_scale = 0.3
		
		await get_tree().create_timer(1).timeout
		get_tree().reload_current_scene()
		
		PlayerManager.is_alive = true
		GameManager.coins = 0

		Engine.time_scale = 1.0
