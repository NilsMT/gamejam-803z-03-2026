extends CharacterBody2D

signal health_depleted

const START_HEALTH = 100.0
const SPEED = 600.0

var health = START_HEALTH

const WEAPON_LIST = [
	preload("res://weapons/needle_thrower.tscn"),
	#preload("res://weapons/scissors.tscn"),
	#preload("res://weapons/button_thrower.tscn"),
	#preload("res://weapons/ruler.tscn"),
]

const WEAPON_ROTATION_OFFSET = [
	0.0,
]

var weapon = null
var choice = 0

@onready var player = get_node("/root/Game/Player")

func switch_weapon(c):
	if c < 0 or c >= WEAPON_LIST.size():
		return

	if weapon:
		weapon.queue_free()

	weapon = WEAPON_LIST[c].instantiate()
	add_child(weapon)
	weapon.position = Vector2.ZERO
	choice = c

func use_weapon():
	if weapon:
		weapon.use()

func _ready():
	switch_weapon(0)
	%ProgressBar.value = health
	%ProgressBar.max_value = START_HEALTH

func _physics_process(delta: float) -> void:
	# Movement
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * SPEED
	move_and_slide()

	# Flip sprite
	if direction.x > 0:
		%Crocky.scale.x = -0.25
	elif direction.x < 0:
		%Crocky.scale.x = 0.25

	# Rotate weapon toward mouse
	if weapon:
		var mouse_pos = get_global_mouse_position()
		weapon.look_at(mouse_pos)
		weapon.rotation += deg_to_rad(WEAPON_ROTATION_OFFSET[choice])

	# Play animations
	if velocity.length() > 0.0:
		%Crocky.play_walk()
	else:
		%Crocky.play_idle()

	# Handle damage
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	for mob in overlapping_mobs:
		health -= mob.DAMAGE * delta

	%ProgressBar.value = health

	if health <= 0.0:
		health_depleted.emit()
		%Crocky.play_death()

func _input(event):
	#use the weapon
	if event.is_action_pressed("attack"):
		use_weapon()
