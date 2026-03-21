extends CharacterBody2D

signal health_depleted

const START_HEALTH = 100.0
const SPEED = 600.0

var health = START_HEALTH

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * SPEED
	move_and_slide()

	if velocity.length() > 0.0:
			%Crocky.play_walk()
	else:
			%Crocky.play_idle()

	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	for mob in overlapping_mobs:
		health -= mob.DAMAGE * delta
	
	%ProgressBar.value = health
	%Crocky.play_hurt()
	if health <= 0.0:
		health_depleted.emit()
		%Crocky.play_death()


func _on_ready() -> void:
	%ProgressBar.value = health
	%ProgressBar.max_value = START_HEALTH
