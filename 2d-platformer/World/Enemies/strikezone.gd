class_name Strikezone extends Area2D


func _on_body_entered(body: Node2D) -> void:
	
	get_parent().speed = 0.0
	
	var i = 0
	for c in get_parent().get_children():
		
		if c is Killzone:
			get_parent().get_child(i).queue_free()
		
		if c is AnimatedSprite2D:
			get_parent().get_child(i).play("die")

		if c is AnimationPlayer:
			get_parent().get_child(i).play("fade")
		i += 1
	
	await get_tree().create_timer(1.0).timeout
	get_parent().queue_free()
