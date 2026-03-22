extends Node2D

var TIME_FOR_GROWTH = Balance.VALUES["game"]["TIME_FOR_GROWTH"] 
var MIN_SPAWN_DISTANCE = Balance.VALUES["game"]["MIN_SPAWN_DISTANCE"]

var spawned_objects = []
var spawned_mobs = []
var nearest_object = null
var current_score = 0
var elapsed_seconds = 0

signal add_score(score)
signal game_ended

var gameover = false
var gamePhase = -1
var phaseTime = [0.0,150.0,300.0,600.0]
var phaseList = [
	[
		"res://mobs/basic/basic_mob.tscn", 50.0,
		"res://mobs/inverter/inverter_mob.tscn", 15.0,
		"res://mobs/fast/fast_mob.tscn", 10.0,
		"res://mobs/big/big_mob.tscn", 10.0,
		"res://mobs/poison/poison_mob.tscn", 5,
	],
	[
		"res://mobs/basic/basic_mob.tscn", 30.0,
		"res://mobs/inverter/inverter_mob.tscn", 20.0,
		"res://mobs/fast/fast_mob.tscn", 15.0,
		"res://mobs/big/big_mob.tscn", 15.0,
		"res://mobs/poison/poison_mob.tscn", 10,
	],
	[
		"res://mobs/matt/matt_mob.tscn", 10.0,
		"res://mobs/big/big_mob.tscn", 90.0,
	],
	[
		"res://mobs/matt/matt_mob.tscn", 100.0,
	]
]









# Spawn chance lists
var PROPS_LIST = [
	"res://props/prop_pearl/prop_pearl.tscn", 1.0,
	"res://props/prop_luma_wii/prop_luma_wii.tscn", 1.0,
	"res://props/prop_thimble/prop_thimble.tscn", 1.0,
	"res://props/prop_mat/prop_mat.tscn", 1.0,
	"res://props/prop_ocarina/prop_ocarina.tscn", 1.0,
	"res://props/prop_pokeball/prop_pokeball.tscn", 1.0,
	"res://props/prop_mask/prop_mask.tscn", 1.0,
]

var OBJECTS_LIST = [
	"res://items/item_weapon_button/item_weapon_button.tscn",22.5,
	"res://items/item_weapon_needle/item_weapon_needle.tscn",22.5,
	"res://items/item_weapon_ruler/item_weapon_ruler.tscn",22.5,
	"res://items/item_medpack/item_medpack.tscn", 10.0,
	#scissors
]

var MOBS_LIST = []

func weighted_random_selection(weighted_list):
	var total_weight = 0.0
	for i in range(0, weighted_list.size(), 2):
		total_weight += weighted_list[i + 1]

	var random_value = randf() * total_weight
	var current_weight = 0.0

	for i in range(0, weighted_list.size(), 2):
		current_weight += weighted_list[i + 1]
		if random_value <= current_weight:
			return weighted_list[i]

	return null

func find_nearest_object():
	var nearest_distance = INF
	nearest_object = null

	# Only check spawned_objects, ignore mobs and props
	for obj in spawned_objects:
		if obj:
			var distance = %Player.global_position.distance_to(obj.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest_object = obj

	return nearest_object

func update_radar():
	if nearest_object:
		%Radar.look_at(nearest_object.global_position)
		%Radar.visible = true
	else:
		%Radar.visible = false

func _ready():
	%GameTime.start()

func _process(delta):
	nearest_object = find_nearest_object()
	update_radar()
	_check_konamicode(delta)












func get_random_far_position():
	# Generate a random angle and distance from the camera
	var angle = randf_range(0, 2 * PI)
	var distance = randf_range(MIN_SPAWN_DISTANCE, MIN_SPAWN_DISTANCE * 2)
	var random_position = %PlayerCamera.global_position + Vector2(cos(angle), sin(angle)) * distance
	return random_position

func spawn_mob():
	var selected_scene = weighted_random_selection(MOBS_LIST)
	if selected_scene:
		var new_mob = load(selected_scene).instantiate()
		new_mob.global_position = get_random_far_position()
		new_mob.DAMAGE *= 1 + elapsed_seconds/TIME_FOR_GROWTH
		new_mob.HEALTH *= 1 + elapsed_seconds/TIME_FOR_GROWTH
		add_child(new_mob)
		spawned_mobs.append(new_mob)
		new_mob.add_to_group("mobs")

func spawn_prop():
	var selected_scene = weighted_random_selection(PROPS_LIST)
	if selected_scene:
		var new_prop = load(selected_scene).instantiate()
		new_prop.global_position = get_random_far_position()
		add_child(new_prop)

func spawn_object():
	var selected_scene = weighted_random_selection(OBJECTS_LIST)
	if selected_scene:
		var new_object = load(selected_scene).instantiate()
		new_object.global_position = get_random_far_position()
		add_child(new_object)
		spawned_objects.append(new_object)










func _on_timer_object_timeout() -> void:
	spawn_object()

func _on_timer_mob_timeout() -> void:
	spawn_mob()

func _on_timer_prop_timeout() -> void:
	spawn_prop()


func _on_add_score(score: Variant) -> void:
	current_score += score
	%UiIngame.set_score_text(current_score)


func _on_game_time_timeout() -> void:
	elapsed_seconds += 0.1
	
	if gameover == false:
		%UiIngame.set_time_text(elapsed_seconds)
		
		if elapsed_seconds <= phaseTime[gamePhase]:
			gamePhase += 1
			MOBS_LIST = phaseList[gamePhase]

func _on_ui_game_over_game_ended() -> void:
	get_tree().call_group("mobs", "queue_free")
	game_ended.emit()










################################################################
# Define the Konami Code sequence using your Input Map actions
var konami_sequence = [
	"move_up",
	"move_up",
	"move_down",
	"move_down",
	"move_left",
	"move_right",
	"move_left",
    "move_right"
]

var input_buffer = []

func _check_konamicode(_delta):
	# Loop over all defined actions and check if they were just pressed
	for action in ["move_up", "move_down", "move_left", "move_right"]:
		if Input.is_action_just_pressed(action):
			input_buffer.append(action)
			# Keep buffer the same length as the sequence
			if input_buffer.size() > konami_sequence.size():
				input_buffer.pop_front()
			
			# Check if the sequence matches
			if input_buffer == konami_sequence:
				_on_konami_code()
				input_buffer.clear()

# Custom function called when Konami Code is entered
func _on_konami_code():
	var selected_scene = "res://mobs/matt/matt_mob.tscn"
	if selected_scene:
		var new_mob = load(selected_scene).instantiate()
		new_mob.global_position = get_random_far_position()
		new_mob.DAMAGE *= 1 + elapsed_seconds/TIME_FOR_GROWTH
		new_mob.HEALTH *= 1 + elapsed_seconds/TIME_FOR_GROWTH
		add_child(new_mob)
		spawned_mobs.append(new_mob)
		new_mob.add_to_group("mobs")


func _on_player_animation_death_done() -> void:
	%UiGameOver.visible = true
	gameover = true
	%UiGameOver.play_animation()
	%Ground.game_ended.emit()
