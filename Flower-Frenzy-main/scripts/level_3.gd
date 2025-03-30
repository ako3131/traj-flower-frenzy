extends Node2D

@onready var character = $coco

var shoe_scene = preload("res://scenes/shoe_monster.tscn")
var bug_scene = preload("res://scenes/bug_monster.tscn")
var flower_scene = preload("res://scenes/level_3_flower.tscn")

func _init() -> void:
	Globals.level = 1

func _ready() -> void:
	character.position = Vector2(1000, 1000)

	# Spawn flowers
	var flower_spawns = get_tree().get_nodes_in_group("flower_marker")
	for marker in flower_spawns:
		var flower = flower_scene.instantiate()
		flower.global_position = marker.global_position
		add_child(flower)

	# Spawn shoes
	var shoe_spawns = get_tree().get_nodes_in_group("shoe_marker")
	for marker in shoe_spawns:
		var shoe = shoe_scene.instantiate()
		shoe.global_position = marker.global_position
		add_child(shoe)

	# Spawn bugs
	var bug_spawns = get_tree().get_nodes_in_group("bug_marker")
	for marker in bug_spawns:
		var bug = bug_scene.instantiate()
		bug.global_position = marker.global_position
		add_child(bug)

# Optional: still allow mouse click spawning (debug or gameplay feature)
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var shoe = shoe_scene.instantiate()
			shoe.global_position = event.position
			add_child(shoe)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			var bug = bug_scene.instantiate()
			bug.global_position = event.position
			add_child(bug)

func _on_fall_area_body_entered(body: Node2D) -> void:
	pass
