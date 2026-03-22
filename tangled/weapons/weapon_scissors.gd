extends Node2D

@onready var scissors_sound = $scissors_sound



var DAMAGE = Balance.VALUES["weapons"]["scissors"]["DAMAGE"]
var ATTACK_SPEED = Balance.VALUES["weapons"]["scissors"]["ATTACK_SPEED"]

func _ready():
	%AnimationPlayer.speed_scale = ATTACK_SPEED

func use():
	if %AnimationPlayer.current_animation != "attack" or not %AnimationPlayer.is_playing():
		scissors_sound.play()
		%AnimationPlayer.play("attack")

func _on_aoe_body_entered(body: Node2D) -> void:
	if body and body.has_method("take_damage"):
		body.take_damage(DAMAGE)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		%AnimationPlayer.play("RESET")
