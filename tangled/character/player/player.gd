extends "res://character/base_character.gd"  # Inherit from base_character.gd

func _ready() -> void:
	super()  # Call parent's _ready
	max_health = 120.0  # Custom player health
	health = max_health
	set_progress_bar($ProgressBar)  # Link ProgressBar

func _get_input_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")
