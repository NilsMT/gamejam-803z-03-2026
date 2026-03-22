extends CharacterBody2D

const BODY_TYPE = 0

var HEALTH = 100
var DAMAGE = 10
const SPEED = 100.0
const SCORE = 20

var busy = false

@onready var player = get_node("/root/InGame/Player")
@onready var game =  get_node("/root/InGame")

func _ready():
	%Angy.play_walk()

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * SPEED
	if busy == true:
		velocity = Vector2.ZERO
	move_and_slide()

func take_damage(damage):
	if not busy:
		HEALTH -= damage
		%Angy.play_hurt()
		
		if HEALTH <= 0:
			busy= true
			%Angy.play_death()
			await %Angy.death_finished
			queue_free()
			game.emit_signal("add_score", SCORE)
