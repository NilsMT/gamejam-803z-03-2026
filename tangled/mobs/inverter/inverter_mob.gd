extends CharacterBody2D

var health = 25
const DAMAGE = 0
const SPEED = 300.0
var EFFECT_ID = 0 # Player.EFFECTS.INVERT_CONTROLS
var EFFECT_DURATION = 10.0

@onready var player = get_node("/root/Game/Player")

func _ready():
	%VeryAngy.play_walk()

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * SPEED
	move_and_slide()

func take_damage(damage):
	health -= damage
	%VeryAngy.play_hurt()
	
	if health <= 0:
		%VeryAngy.play_death()
		queue_free()
