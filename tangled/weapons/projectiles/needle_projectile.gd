extends Area2D

const DAMAGE = 20.0
const MAX_PENETRATION = 2
const SPEED = 500.0

var penetration_left = MAX_PENETRATION

func _ready():
	%Timer.start()

func fire():
	pass  # Movement is handled in _physics_process

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(DAMAGE)
		penetration_left -= 1
		if penetration_left <= 0:
			queue_free()

func _on_timer_timeout():
	queue_free()
