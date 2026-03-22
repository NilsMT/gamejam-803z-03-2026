extends Node2D

@onready var button_sound = $button_sound

const BUTTON_PROJECTILE = preload("res://weapons/projectiles/button_projectile.tscn")

func use():
	pass



func _on_timer_timeout() -> void:
	button_sound.play()
	var projectile = BUTTON_PROJECTILE.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_position = %Handle.global_position
	projectile.rotation = %Handle.global_rotation
