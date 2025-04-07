extends Node2D

@onready var character = $coco
var shoe_scene = preload("res://scenes/converse_monster.tscn")
var caterpillar_scene = preload("res://scenes/caterpillar_monster.tscn")
var flower_scene = preload("res://scenes/level_0_flower.tscn")

func _init() -> void:
	# Update the global level variable before _ready() is called
	Globals.level = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character.position = Vector2(-900, 719)
	
	# Get all markers in the scene
	var bug_spawn_points = get_tree().get_nodes_in_group("bug_spawns")

	for marker in bug_spawn_points:
		var mob = caterpillar_scene.instantiate()
		mob.global_position = marker.global_position
		add_child(mob)
		
	# Get all markers in the scene
	var shoe_spawn_points = get_tree().get_nodes_in_group("shoe_spawns")

	for marker in shoe_spawn_points:
		var mob = shoe_scene.instantiate()
		mob.global_position = marker.global_position
		add_child(mob)
		
	# Get all markers in the scene
	var flower_spawn_points = get_tree().get_nodes_in_group("flower_spawns")

	for marker in flower_spawn_points:
		var mob = flower_scene.instantiate()
		mob.global_position = marker.global_position
		add_child(mob)
