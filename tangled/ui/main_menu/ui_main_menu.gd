extends CanvasLayer

signal playing


func _on_texture_button_pressed() -> void:
	playing.emit()
