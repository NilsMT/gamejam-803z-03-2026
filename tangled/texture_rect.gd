extends TextureRect

signal game_ended

var is_game_ended = false
@onready var mat := material
var scroll_offset := Vector2.ZERO

func _process(delta):
	if is_game_ended:
		return

	# Move the TextureRect to follow the player
	var pos = %Player.global_position
	pos -= size
	global_position = pos

	# Apply the player's velocity directly to the scroll offset
	# Multiply by delta to account for frame time
	scroll_offset -= (%Player.velocity * -1) * delta * 0.000505  # Adjust 0.001 to match your game's scale

	# Wrap around for seamless tiling
	scroll_offset.x = fmod(scroll_offset.x, 1.0)
	scroll_offset.y = fmod(scroll_offset.y, 1.0)

	# Apply to shader
	mat.set_shader_parameter("offset", scroll_offset)

func _on_game_ended() -> void:
	is_game_ended = true
	scroll_offset = Vector2.ZERO
