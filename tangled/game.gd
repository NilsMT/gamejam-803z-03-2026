extends Node2D

@onready var ingame =  preload("res://in_game.tscn")
var current_game = null

func _on_ui_game_menu_playing() -> void:
	if current_game != null:
		return
	
	current_game = ingame.instantiate()
	%UiGameMenu.visible = false
	current_game.connect("game_ended", _on_game_ended)
	add_child(current_game)
	
func _on_game_ended():
	%UiGameMenu.visible = true
	current_game.queue_free()
