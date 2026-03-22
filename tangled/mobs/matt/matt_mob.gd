extends CharacterBody2D

const BODY_TYPE = 0

var HEALTH = 0.001
var DAMAGE = 1000
const SPEED = 2000.0
const SCORE = 1000

var busy = false

@onready var player = get_parent().get_node("Player")
@onready var game = get_parent()

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * SPEED
	move_and_slide()

func take_damage(damage):
	if not busy:
		HEALTH -= damage
		
		if HEALTH <= 0:
			busy= true
			queue_free()
			game.emit_signal("add_score", SCORE)
