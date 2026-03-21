extends CharacterBody2D

signal health_depleted

const MAX_HEALTH = 100.0
var health = MAX_HEALTH
const MAX_EFFECT_DURATION = 5.0
const SPEED = 600.0

enum EFFECTS {
	INVERT_CONTROLS,
}

var active_effects := {}

const WEAPON_LIST = [
	preload("res://weapons/weapon_needle.tscn"),
	preload("res://weapons/weapon_button.tscn"),
	preload("res://weapons/weapon_ruler.tscn"),
	preload("res://weapons/weapon_scissors.tscn"),
]

var weapon = null
var choice = 2

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
	switch_weapon(choice)
	%ProgressBar.value = health
	%ProgressBar.max_value = MAX_HEALTH

func _physics_process(delta: float) -> void:
	
	#effect management
	_update_effects(delta)
	
	# Movement
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	#inverter effect
	if EFFECTS.INVERT_CONTROLS in active_effects:
		direction *= -1
		if %AnimationPlayer.current_animation != "confused":
			%AnimationPlayer.play("confused")
	elif %AnimationPlayer.current_animation == "confused":
		%AnimationPlayer.play("RESET")
	
	velocity = direction * SPEED
	move_and_slide()

	# Flip sprite
	if direction.x > 0:
		%Crocky.scale.x = -0.25
	elif direction.x < 0:
		%Crocky.scale.x = 0.25

	# Rotate weapon toward mouse
	if weapon:
		if weapon.get("FOLLOW_MOUSE") != null and not weapon.FOLLOW_MOUSE:
			# Spin the weapon (frame-rate independent)
			weapon.rotation += deg_to_rad(weapon.SPIN_SPEED * delta)
		else:
			# Follow mouse
			var mouse_pos = get_global_mouse_position()
			weapon.look_at(mouse_pos)

	# Play animations
	if velocity.length() > 0.0:
		%Crocky.play_walk()
	else:
		%Crocky.play_idle()

	#handle bodies (mobs & items)
	_handle_bodies(delta)
	
	%ProgressBar.value = health

	if health <= 0.0:
		health_depleted.emit()
		%Crocky.play_death()

func _update_effects(delta: float) -> void:
	var to_remove := []
	for effect in active_effects.keys():
		active_effects[effect] -= delta
		if active_effects[effect] <= 0.001:
			to_remove.append(effect)
	for effect in to_remove:
		active_effects.erase(effect)

func _apply_effect(effect_id: int, duration: float) -> void:
	if effect_id in active_effects:
		active_effects[effect_id] = min(
			active_effects[effect_id] + duration,
			MAX_EFFECT_DURATION
		)
	else:
		active_effects[effect_id] = duration

func _handle_bodies(delta: float) -> void:
	var overlapping_bodies = %HurtBox.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		match body.BODY_TYPE:
			0:
				health -= body.DAMAGE * delta
				
				if body.get("EFFECT_ID") != null:
					var effect_id = body.EFFECT_ID
					_apply_effect(effect_id, body.EFFECT_DURATION)
			1:
				if (health + body.HEAL) > MAX_HEALTH:
					health = MAX_HEALTH
				else:
					health += body.HEAL
				body.queue_free()
			2:
				switch_weapon(body.WEAPON_TYPE)
				body.queue_free()

func _input(event):
	#use the weapon
	if event.is_action_pressed("attack"):
		use_weapon()
