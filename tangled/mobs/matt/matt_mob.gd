extends CharacterBody2D

const BODY_TYPE = 0



var HEALTH = Balance.VALUES["mobs"]["matt_mob"]["HEALTH"]
var DAMAGE = Balance.VALUES["mobs"]["matt_mob"]["DAMAGE"]
var SPEED = Balance.VALUES["mobs"]["matt_mob"]["SPEED"]
var SCORE = Balance.VALUES["mobs"]["matt_mob"]["SCORE"]

var busy = false
var canMove = false

@onready var player = get_parent().get_node("Player")
@onready var game = get_parent()

func _ready():
	%MattSpawn.play()
	await %MattSpawn.finished
	canMove = true

func _physics_process(_delta: float) -> void:
	if not canMove:
		return
	
	if busy:
		return
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
