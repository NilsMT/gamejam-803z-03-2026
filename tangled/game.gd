extends Node2D

@onready var ingame =  preload("res://in_game.tscn")
var current_game = null
var areMusicsMuted = false

func _ready():
	%music_menu.play()

func _on_ui_game_menu_playing() -> void:
	if current_game != null:
		return
	
	%music_menu.stop()
	current_game = ingame.instantiate()
	%UiGameMenu.visible = false
	current_game.connect("game_ended", _on_game_ended)
	add_child(current_game)
	current_game.music_mute.emit(areMusicsMuted)
	
func _on_game_ended():
	%UiGameMenu.visible = true
	current_game.queue_free()
	%music_menu.play()

func _on_ui_game_menu_muted_audio(muted: Variant) -> void:
	%music_menu.volume_db = -80.0 if muted else -10.0
	areMusicsMuted = muted
