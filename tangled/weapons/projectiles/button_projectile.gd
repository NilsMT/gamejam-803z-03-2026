extends Area2D



var DAMAGE = Balance.VALUES["weapons"]["button"]["projectile"]["DAMAGE"]
var MAX_PENETRATION = Balance.VALUES["weapons"]["button"]["projectile"]["MAX_PENETRATION"]
var SPEED = Balance.VALUES["weapons"]["button"]["projectile"]["SPEED"]
var LIFETIME = Balance.VALUES["weapons"]["button"]["projectile"]["LIFETIME"]

var penetration_left = MAX_PENETRATION

func _ready():
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
