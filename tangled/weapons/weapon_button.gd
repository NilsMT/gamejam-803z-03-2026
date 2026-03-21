extends Node2D

const BUTTON_PROJECTILE = preload("res://weapons/projectiles/button_projectile.tscn")

func use():
	pass



func _on_timer_timeout() -> void:
	var projectile = BUTTON_PROJECTILE.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_position = %Handle.global_position
	projectile.rotation = %Handle.global_rotation
