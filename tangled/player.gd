extends CharacterBody2D

@onready var effect_audio = $crocky_stunned
@onready var crocky_death = $crocky_death

signal health_depleted

const MAX_HEALTH = 100.0
var health = MAX_HEALTH
const MAX_EFFECT_DURATION = 5.0
const SPEED = 600.0

var is_game_ended = false

enum EFFECTS {
	INVERT_CONTROLS,
	POISON
}

var active_effects = {}







const WEAPON_LIST = [
	preload("res://weapons/weapon_needle.tscn"),
	preload("res://weapons/weapon_button.tscn"),
	preload("res://weapons/weapon_ruler.tscn"),
	preload("res://weapons/weapon_scissors.tscn"),
]

var weapon = null
var choice = 1

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

func _input(event):
	#use the weapon
	if event.is_action_pressed("attack"):
		use_weapon()











func _ready():
	switch_weapon(choice)
	%ProgressBar.value = health
	%ProgressBar.max_value = MAX_HEALTH

func _physics_process(delta: float) -> void:
	if is_game_ended == false:
		#effect management
		_update_effects(delta)
		
		# Movement
		var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		if is_game_ended:
			input_direction = Vector2.ZERO
		
		#Effects
		input_direction = handle_effects(delta,input_direction)
		
		velocity = input_direction * SPEED
		move_and_slide()

		# Flip sprite
		if input_direction.x > 0:
			%Crocky.scale.x = -0.5
		elif input_direction.x < 0:
			%Crocky.scale.x = 0.5

		# Rotate weapon toward mouse
		handle_weapon_rotation(delta)

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
			is_game_ended = true
			weapon.queue_free()
			crocky_death.play()
			%Crocky.play_death()








func handle_weapon_rotation(delta):
	if not weapon:
		return

	if weapon.get("FOLLOW_MOUSE") and not weapon.FOLLOW_MOUSE:
		weapon.rotation += deg_to_rad(weapon.SPIN_SPEED * delta)
	else:
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - weapon.global_position).normalized()
		var angle_deg = rad_to_deg(direction.angle())

		# Rotate weapon
		weapon.look_at(mouse_pos)

		# Flip inner object if aiming left
		var handle = weapon.get_node("Handle")
		if handle.has_node("Object"):
			var obj = handle.get_node("Object")
			obj.scale.y = -1 if angle_deg > 90 or angle_deg < -90 else 1
		elif handle.has_node("AOE/Object"):
			var obj = handle.get_node("AOE/Object")
			obj.scale.y = -1 if angle_deg > 90 or angle_deg < -90 else 1

func handle_effects(delta,input_direction) -> Vector2:
	if EFFECTS.INVERT_CONTROLS in active_effects:
		input_direction *= -1
		if %AnimationPlayerConfused.current_animation != "confused":
			if not effect_audio.playing:
				effect_audio.play()
				%AnimationPlayerConfused.play("confused")
			else:
				%AnimationPlayerConfused.play("RESET")

	if EFFECTS.POISON in active_effects:
		health -= 0.1
		if %AnimationPlayerPoisoned.current_animation != "poisoned":
			if not effect_audio.playing:
				effect_audio.play()
			%AnimationPlayerPoisoned.play("poisoned")
	else:
		%AnimationPlayerPoisoned.play("RESET")
		
	return input_direction







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
