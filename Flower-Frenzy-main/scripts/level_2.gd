extends Node2D

var flower_scene = preload("res://scenes/level_2_flower.tscn")
#var caterpillar_scene = preload("res://scenes/caterpillar_monster.tscn")

func _init() -> void:
	# Update the global level variable before _ready() is called
	Globals.level = 2
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get all markers in the scene
	var flower_spawns = get_tree().get_nodes_in_group("flower_markers")
	print("Number of flower markers found: ", flower_spawns.size())

	for marker in flower_spawns:
		var flower = flower_scene.instantiate()
		flower.global_position = marker.global_position
		add_child(flower)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
