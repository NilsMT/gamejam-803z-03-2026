extends Node2D

var mag_capacity = 0
const MAX_MAG_CAPACITY = 3
const NEEDLE_MODEL = preload("res://objects/needle/needle.tscn")
const NEEDLE_PROJECTILE = preload("res://weapons/projectiles/needle_projectile.tscn")

var needles = []  # Array to hold visual needles

func _ready():
	# Fill the magazine with visual needles
	for i in range(MAX_MAG_CAPACITY):
		var needle = NEEDLE_MODEL.instantiate()
		add_child(needle)
		needle.position = Vector2(0, 0)
		needle.rotation = deg_to_rad(i * 10)
		needles.append(needle)
	mag_capacity = MAX_MAG_CAPACITY

func use():
	if mag_capacity > 0:
		mag_capacity -= 1
		# Hide the visual needle
		var visual_needle = needles[mag_capacity]
		visual_needle.visible = false

		# Spawn a functional projectile
		var projectile = NEEDLE_PROJECTILE.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = global_position
		projectile.rotation = rotation + deg_to_rad(90.0)  # Align with weapon

		if mag_capacity == 0:
			%ReloadTimer.start()

func _on_reload_timer_timeout():
	if mag_capacity < MAX_MAG_CAPACITY:
		# Show the next hidden needle
		var next_needle = needles[mag_capacity]
		next_needle.visible = true
		mag_capacity += 1

		if mag_capacity < MAX_MAG_CAPACITY:
			%ReloadTimer.start()
		else:
			%ReloadTimer.stop()
