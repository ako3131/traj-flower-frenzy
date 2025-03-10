extends Node2D

@onready var character = $coco
var shoe_scene = preload("res://scenes/shoe_monster.tscn")
var bug_scene = preload("res://scenes/bug_monster.tscn")

func _ready() -> void:
	character.position = Vector2(551, 482)
	
	# Spawn initial monsters
	create_shoes(2)  # Spawn 3 shoe monsters
	create_bugs(2)   # Spawn 2 bug monsters
	
	# Spawn additional monsters at specific positions
	spawn_shoe_monster(Vector2(2100, 500))
	spawn_shoe_monster(Vector2(4600, 500))
	spawn_shoe_monster(Vector2(4800, 500))
	spawn_shoe_monster(Vector2(6000, 500))
	spawn_shoe_monster(Vector2(8000, 1500))
	spawn_shoe_monster(Vector2(9000, 1500))
	spawn_shoe_monster(Vector2(9200, 1500))
	spawn_bug_monster(Vector2(3100, 500))
	spawn_bug_monster(Vector2(3500, 500))
	spawn_bug_monster(Vector2(4500, 1000))
	spawn_bug_monster(Vector2(4500, 1600))
	spawn_bug_monster(Vector2(5000, 1600))
	spawn_bug_monster(Vector2(5500, 1600))
	spawn_bug_monster(Vector2(7150, 2000))
	spawn_bug_monster(Vector2(7250, 2000))
	spawn_bug_monster(Vector2(7350, 2000))


# Function to spawn a shoe monster at a specific position
func spawn_shoe_monster(pos: Vector2) -> void:
	var shoe = shoe_scene.instantiate()
	add_child(shoe)
	shoe.position = pos

# Function to spawn a bug monster at a specific position
func spawn_bug_monster(pos: Vector2) -> void:
	var bug = bug_scene.instantiate()
	add_child(bug)
	bug.position = pos

# Input handling for monster spawning
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Spawn shoe monster with left click
			spawn_shoe_monster(event.position)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			# Spawn bug monster with right click
			spawn_bug_monster(event.position)

func create_shoes(count: int):
	var x_change = 70
	var y_change = -50
	var x = 881
	var y = 389
	for i in range(count):
		var shoe = shoe_scene.instantiate()
		add_child(shoe)
		shoe.position = Vector2(x + (x_change * i), y + (y_change * i))
	
func create_bugs(count: int):
	var x_change = 100
	var y_change = 0
	var x = 130
	var y = 511
	for i in range(count):
		var bug = bug_scene.instantiate()
		add_child(bug)
		bug.position = Vector2(x + (x_change * i), y + (y_change * i))


func _on_fall_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
