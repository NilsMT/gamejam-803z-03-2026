extends CharacterBody2D

var health = 3
const DAMAGE = 5
const SPEED = 300.0

@onready var player = get_node("/root/Game/Player")

func _ready():
	%Angy.play_walk()

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * SPEED
	velocity *= delta
	move_and_slide()
	

func take_damage():
	health -= 1
	%Angy.play_hurt()
	
	if health == 0:
		%Angy.play_dead()
		#TODO: wait until animation is done
		queue_free()
		
