extends AudioStreamPlayer


func xxx(muted: Variant) -> void:
	volume_db = -80.0 if muted else -10.0
