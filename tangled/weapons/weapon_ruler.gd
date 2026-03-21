extends Node2D

var DAMAGE = 5
const FOLLOW_MOUSE = false
var SPIN_SPEED = 500.0

var isExtended = false

func use():
	%AnimationPlayer.stop()  # Stop the current animation
	if isExtended:
		isExtended = false
		%AnimationPlayer.play("reduce")
		DAMAGE /= 2
		SPIN_SPEED *= 2
	else:
		isExtended = true
		%AnimationPlayer.play("extend")
		DAMAGE *= 2
		SPIN_SPEED /= 2

func _on_body_entered_in_aoe(body: Node2D) -> void:
	if body and body.has_method("take_damage"):
		body.take_damage(DAMAGE)

func _on_aoe_body_entered(body: Node2D) -> void:
	_on_body_entered_in_aoe(body)

func _on_extended_aoe_body_entered(body: Node2D) -> void:
	_on_body_entered_in_aoe(body)
