extends CharacterBody2D

const BODY_TYPE = 0



var HEALTH = 0
var DAMAGE = 0
var SPEED = 0
var SCORE = 0

var EFFECT_ID = 0 # Player.EFFECTS.INVERT_CONTROLS
var EFFECT_DURATION = 0

var busy = false

@onready var player = get_parent().get_node("Player")
@onready var game = get_parent()

func _ready():
	HEALTH = Balance.VALUES["mobs"]["inverter_mob"]["HEALTH"]
	DAMAGE = Balance.VALUES["mobs"]["inverter_mob"]["DAMAGE"]
	SPEED = Balance.VALUES["mobs"]["inverter_mob"]["SPEED"]
	SCORE = Balance.VALUES["mobs"]["inverter_mob"]["SCORE"]
	EFFECT_DURATION = Balance.VALUES["mobs"]["inverter_mob"]["EFFECT_DURATION"]
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
