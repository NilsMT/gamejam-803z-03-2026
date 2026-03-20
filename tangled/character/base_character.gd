extends CharacterBody2D

# Signals
signal health_depleted
signal health_changed(new_health: float)

# Exported variables (customizable in the editor)
@export var max_health: float = 100.0
@export var speed: float = 600.0
@export var damage_rate: float = 5.0

# Internal variables
var health: float
var hurtbox: Area2D
var progress_bar: ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = max_health
	hurtbox = $HurtBox
	# Connect the hurtbox's body_entered signal if needed
	# hurtbox.body_entered.connect(_on_hurtbox_body_entered)

# Physics process for movement
func _physics_process(delta: float) -> void:
	var direction: Vector2 = _get_input_direction()
	velocity = direction * speed
	move_and_slide()

	# Emit animation signals or play animations here
	if velocity.length() > 0.0:
		pass  # Replace with animation logic
	else:
		pass  # Replace with animation logic

	# Handle damage from overlapping bodies
	var overlapping_mobs = hurtbox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		_take_damage(damage_rate * overlapping_mobs.size() * delta)

# Helper function to get input direction (override for enemies)
func _get_input_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_up", "move_down")

# Damage handling
func _take_damage(amount: float) -> void:
	health -= amount
	health = max(health, 0.0)
	health_changed.emit(health)
	if progress_bar:
		progress_bar.value = health
	if health <= 0.0:
		health_depleted.emit()

# Optional: Function to set the progress bar reference
func set_progress_bar(pb: ProgressBar) -> void:
	progress_bar = pb
	progress_bar.max_value = max_health
	progress_bar.value = health
