extends Node2D

@onready var ruler_woosh = $ruler_woosh
@onready var ruler_spin = $ruler_spin

var DAMAGE = 5
const FOLLOW_MOUSE = false
var SPIN_SPEED = 500.0
var SPIN_CHECK = 0.0

var isExtended = false

func _process(delta):
	var rotation_this_frame = SPIN_SPEED * delta
	SPIN_CHECK += rotation_this_frame
	
	# Check if we completed one or more full rotations
	if SPIN_CHECK >= 180.0:
		ruler_spin.play()
		SPIN_CHECK = fmod(SPIN_CHECK, 180.0)  # Keep the remainder
	rotation_degrees += rotation_this_frame

func use():
	ruler_woosh.play()
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
	if SPIN_CHECK == SPIN_SPEED + 360.0:
		ruler_spin.play()
		SPIN_CHECK = SPIN_SPEED

func _on_body_entered_in_aoe(body: Node2D) -> void:
	if body and body.has_method("take_damage"):
		body.take_damage(DAMAGE)

func _on_aoe_body_entered(body: Node2D) -> void:
	_on_body_entered_in_aoe(body)

func _on_extended_aoe_body_entered(body: Node2D) -> void:
	_on_body_entered_in_aoe(body)
