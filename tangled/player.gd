extends CharacterBody2D

signal health_depleted

const START_HEALTH = 100.0
var health = START_HEALTH

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left","move_right","move_up","move_down")
	velocity = direction * 600
	move_and_slide()

	if velocity.length() > 0.0:
		%Crocky.play_walk()
	else:
		%Crocky.play_idle()
	
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		%Crocky.play_hurt()
		
		print("pd")
		
		if health <= 0.0:
			health_depleted.emit()
			%Crocky.play_death()


func _on_ready() -> void:
	%ProgressBar.value = health
	%ProgressBar.max_value = START_HEALTH
