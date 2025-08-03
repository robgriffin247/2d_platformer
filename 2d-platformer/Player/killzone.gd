class_name Killzone extends Node


func _on_body_entered(_body: Node2D) -> void:
	if PlayerManager.is_alive:
		PlayerManager.die()
		
