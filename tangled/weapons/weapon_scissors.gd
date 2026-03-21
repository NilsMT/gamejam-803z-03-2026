extends Node2D

var DAMAGE = 12.5

func use():
	if %AnimationPlayer.current_animation != "attack" or not %AnimationPlayer.is_playing():
		%AnimationPlayer.play("attack")

func _on_aoe_body_entered(body: Node2D) -> void:
	if body and body.has_method("take_damage"):
		body.take_damage(DAMAGE)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		%AnimationPlayer.play("RESET")
