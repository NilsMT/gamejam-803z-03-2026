extends Area2D



var DAMAGE = 0
var MAX_PENETRATION = 0
var SPEED = 0
var LIFETIME = 0

var penetration_left = MAX_PENETRATION

func _ready():
	DAMAGE = Balance.VALUES["weapons"]["needle"]["projectile"]["DAMAGE"]
	MAX_PENETRATION = Balance.VALUES["weapons"]["needle"]["projectile"]["MAX_PENETRATION"]
	SPEED = Balance.VALUES["weapons"]["needle"]["projectile"]["SPEED"]
	LIFETIME = Balance.VALUES["weapons"]["needle"]["projectile"]["LIFETIME"]
	%Timer.wait_time = LIFETIME
	%Timer.start()

func fire():
	pass  # Movement is handled in _physics_process

func _physics_process(delta):
	var direction = Vector2.DOWN.rotated(rotation)
	position += direction * SPEED * delta

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(DAMAGE)
		penetration_left -= 1
		if penetration_left <= 0:
			queue_free()

func _on_timer_timeout():
	queue_free()
