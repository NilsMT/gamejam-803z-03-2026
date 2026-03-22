extends Node2D

@onready var ruler_woosh = $ruler_woosh
@onready var ruler_spin = $ruler_spin


const FOLLOW_MOUSE = false



var SPIN_SPEED = 0
var RATIO_MODE = 0
var DAMAGE = 0

var SPIN_CHECK = 0.0

var isExtended = false

func _ready():
	SPIN_SPEED = Balance.VALUES["weapons"]["ruler"]["SPIN_SPEED"]
	RATIO_MODE = Balance.VALUES["weapons"]["ruler"]["RATIO_MODE"]
	DAMAGE = Balance.VALUES["weapons"]["ruler"]["DAMAGE"]

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
		DAMAGE /= RATIO_MODE
		SPIN_SPEED *= RATIO_MODE
	else:
		isExtended = true
		%AnimationPlayer.play("extend")
		DAMAGE *= RATIO_MODE
		SPIN_SPEED /= RATIO_MODE
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
