extends "res://character/base_character.gd"  # Inherit from base_character.gd

func _get_input_direction() -> Vector2:  # Override for AI movement
	var player = get_tree().get_first_node_in_group("players")
	if player:
		return (player.global_position - global_position).normalized()
	return Vector2.ZERO
