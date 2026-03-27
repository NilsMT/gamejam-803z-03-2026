extends CanvasLayer

signal playing
signal muted_audio(muted)

var muted = false

func _on_texture_button_pressed() -> void:
	playing.emit()


func _on_mute_pressed() -> void:
	muted = not muted
	muted_audio.emit(muted)
	if muted:
		%Mute.texture_normal = load("res://ui/main_menu/music_mute.png")
	else:
		%Mute.texture_normal = load("res://ui/main_menu/music_unmute.png")
