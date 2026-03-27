extends AudioStreamPlayer


func _on_in_game_music_mute(muted: Variant) -> void:
	volume_db = -80.0 if muted else -10.0
