extends TextureRect

signal game_ended

var is_game_ended = false

@onready var mat := material

var scroll_offset := Vector2.ZERO
var smoothing := 8.0

func _process(delta):
	if not is_game_ended:
		var pos = %Player.global_position
		
		pos -= size
		
		global_position = pos
		
		# accumulate scroll based on player velocity
		scroll_offset += (%Player.velocity * delta) * 0.0005  # tweak speed

		# optional: smooth the scroll
		var smooth_offset = scroll_offset.lerp(scroll_offset, delta * smoothing)  # can skip if you like

		# keep the offset in 0-1 range to loop seamlessly
		smooth_offset.x = fmod(smooth_offset.x, 1.0)
		smooth_offset.y = fmod(smooth_offset.y, 1.0)

		# apply to shader
		mat.set_shader_parameter("offset", smooth_offset)


func _on_game_ended() -> void:
	is_game_ended = true
