extends CanvasLayer

signal game_ended

func play_animation():
	%AnimationPlayer.play("game_over")
	



func _on_texture_button_pressed() -> void:
	game_ended.emit()
