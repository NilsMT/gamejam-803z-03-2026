extends Node2D

var spawned_objects = []
var spawned_mobs = []

# .tscn spawn_chance
var PROPS_LIST = [
	"res://props/pearl/pearl.tscn", 0.0,
]

# .tscn spawn_chance
var OBJECTS_LIST = [
	"res://objects/medpack/medpack.tscn", 0.0,
]

# .tscn spawn_chance
var MOBS_LIST = [
	"res://mobs/basic/basic_mob.tscn", 90.0,
]

func weighted_random_selection(weighted_list):
	var total_weight = 0.0
	# Calculate total weight (sum of all chances)
	for i in range(0, weighted_list.size(), 2):
		total_weight += weighted_list[i + 1]

	# Generate a random value between 0 and total_weight
	var random_value = randf() * total_weight
	var current_weight = 0.0

	# Iterate through the list to find the selected scene
	for i in range(0, weighted_list.size(), 2):
		current_weight += weighted_list[i + 1]
		if random_value <= current_weight:
			return weighted_list[i]  # Return the scene path

	return null  # Fallback (should not happen if weights are correct)


func spawn_mob():
	var selected_scene = weighted_random_selection(MOBS_LIST)
	if selected_scene:
		var new_mob = load(selected_scene).instantiate()
		%MarkerMob.progress_ratio = randf()
		new_mob.global_position = %MarkerMob.global_position
		add_child(new_mob)
		spawned_mobs.append(new_mob)


func spawn_prop():
	var selected_scene = weighted_random_selection(PROPS_LIST)
	if selected_scene:
		var new_prop = load(selected_scene).instantiate()
		%MarkerProp.progress_ratio = randf()
		new_prop.global_position = %MarkerProp.global_position
		add_child(new_prop)


func spawn_object():
	var selected_scene = weighted_random_selection(OBJECTS_LIST)
	if selected_scene:
		var new_object = load(selected_scene).instantiate()
		%MarkerProp.progress_ratio = randf()
		new_object.global_position = %MarkerProp.global_position
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
