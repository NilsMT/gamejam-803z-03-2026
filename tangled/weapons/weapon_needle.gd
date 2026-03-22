extends Node2D

@onready var needle_sound = $needle_sound

var mag_capacity = 0
const MAX_MAG_CAPACITY = 3
const NEEDLE_MODEL = preload("res://objects/object_needle/object_needle.tscn")
const NEEDLE_PROJECTILE = preload("res://weapons/projectiles/needle_projectile.tscn")

var needles = []  # Array to hold visual needles

func _ready():
	# Fill the magazine with visual needles
	for i in range(MAX_MAG_CAPACITY):
		var needle = NEEDLE_MODEL.instantiate()
		add_child(needle)
		needle.position = %Handle.position  # Position at handle
		needle.rotation = %Handle.rotation + deg_to_rad(i * 10)
		needles.append(needle)
	
	mag_capacity = MAX_MAG_CAPACITY

func use():
	if mag_capacity > 0:
		needle_sound.play()
		mag_capacity -= 1
		# Hide the visual needle
		var visual_needle = needles[mag_capacity]
		visual_needle.visible = false

		# Spawn a functional projectile at the handle position
		var projectile = NEEDLE_PROJECTILE.instantiate()
		get_tree().root.add_child(projectile)
		projectile.global_position = %Handle.global_position
		projectile.rotation = %Handle.global_rotation  # Align with handle

		if mag_capacity == 0:
			%ReloadTimer.start()

func _on_reload_timer_timeout():
	if mag_capacity < MAX_MAG_CAPACITY:
		# Show the next hidden needle
		var next_needle = needles[mag_capacity]
		next_needle.position = %Handle.position  # Position at handle
		next_needle.visible = true
		mag_capacity += 1

		if mag_capacity < MAX_MAG_CAPACITY:
			%ReloadTimer.start()
		else:
			%ReloadTimer.stop()
