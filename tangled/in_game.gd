extends Node2D

var spawned_objects = []
var spawned_mobs = []
var nearest_object = null
var current_score = 0

signal add_score(score)

# Spawn chance lists
var PROPS_LIST = [
	"res://props/prop_pearl/prop_pearl.tscn", 1.0,
	"res://props/prop_luma_wii/prop_luma_wii.tscn", 1.0,
	"res://props/prop_thimble/prop_thimble.tscn", 1.0,
]

var OBJECTS_LIST = [
	"res://items/item_weapon_button/item_weapon_button.tscn",22.5,
	"res://items/item_weapon_needle/item_weapon_needle.tscn",22.5,
	"res://items/item_weapon_ruler/item_weapon_ruler.tscn",22.5,
	"res://items/item_medpack/item_medpack.tscn", 10.0,
	#scissors
]

var MOBS_LIST = [
	"res://mobs/basic/basic_mob.tscn", 90.0,
	"res://mobs/inverter/inverter_mob.tscn", 9.99,
	#mii de la mort, 0.01
]

# Define a minimum spawn distance from the camera
const MIN_SPAWN_DISTANCE = 1000.0

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

func _process(_delta):
	nearest_object = find_nearest_object()
	update_radar()

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
		add_child(new_mob)
		spawned_mobs.append(new_mob)

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

func _on_player_health_depleted() -> void:
	%GameOver.visible = true
	get_tree().paused = true

func _on_timer_object_timeout() -> void:
	spawn_object()

func _on_timer_mob_timeout() -> void:
	spawn_mob()

func _on_timer_prop_timeout() -> void:
	spawn_prop()


func _on_add_score(score: Variant) -> void:
	current_score += score
