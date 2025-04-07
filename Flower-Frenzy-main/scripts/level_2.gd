extends Node2D

var flower_scene = preload("res://scenes/level_2_flower.tscn")
var snail_scene = preload("res://scenes/snail_monster.tscn")
var sandal_scene = preload("res://scenes/sandal_monster.tscn")
var coco_scene = preload("res://scenes/coco.tscn")

func _init() -> void:
	# Update the global level variable before _ready() is called
	Globals.level = 2
	
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
	var snail_spawns = get_tree().get_nodes_in_group("snail_markers")

	for marker in snail_spawns:
		var mob = snail_scene.instantiate()
		mob.global_position = marker.global_position
		add_child(mob)

	# Get all markers in the scene
	var sandal_spawns = get_tree().get_nodes_in_group("sandal_markers")

	for marker in sandal_spawns:
		var mob = sandal_scene.instantiate()
		mob.global_position = marker.global_position
		add_child(mob)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
