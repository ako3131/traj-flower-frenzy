extends Node2D

var flower_scene = preload("res://scenes/level_1_flower.tscn")
var bug_scene = preload("res://scenes/caterpillar_monster.tscn")
var shoe_scene = preload("res://scenes/converse_monster.tscn")
var coco_scene = preload("res://scenes/coco.tscn")

func _init() -> void:
	# Update the global level variable before _ready() is called
	Globals.level = 1
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var character = coco_scene.instantiate()
	character.global_position = $player_marker.global_position
	add_child(character)
	
	# Get all markers in the scene
	var flower_spawns = get_tree().get_nodes_in_group("flower_markers")

	for marker in flower_spawns:
		var flower = flower_scene.instantiate()
		flower.global_position = marker.global_position
		add_child(flower)
		
	# Get all markers in the scene
	var bug_spawns = get_tree().get_nodes_in_group("bug_markers")

	for marker in bug_spawns:
		var mob = bug_scene.instantiate()
		mob.global_position = marker.global_position
		add_child(mob)

	# Get all markers in the scene
	var shoe_spawns = get_tree().get_nodes_in_group("shoe_markers")

	for marker in shoe_spawns:
		var mob = shoe_scene.instantiate()
		mob.global_position = marker.global_position
		add_child(mob)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
