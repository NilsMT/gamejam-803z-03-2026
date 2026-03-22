extends CharacterBody2D

const BODY_TYPE = 0



var HEALTH = Balance.VALUES["mobs"]["big_mob"]["HEALTH"]
var DAMAGE = Balance.VALUES["mobs"]["big_mob"]["DAMAGE"]
var SPEED = Balance.VALUES["mobs"]["big_mob"]["SPEED"]
var SCORE = Balance.VALUES["mobs"]["big_mob"]["SCORE"]

var busy = false

@onready var player = get_parent().get_node("Player")
@onready var game = get_parent()

func _ready():
	%Angy.play_walk()

func _physics_process(_delta: float) -> void:
	if busy:
		return
	var direction = global_position.direction_to(player.global_position)
	
	velocity = direction * SPEED
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
