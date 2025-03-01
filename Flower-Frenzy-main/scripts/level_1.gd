extends Node2D

@onready var character = $coco
var shoe_scene = preload("res://scenes/shoe_monster.tscn")
var bug_scene = preload("res://scenes/bug_monster.tscn")

func _ready() -> void:
	character.position = Vector2(551, 482)
	
	create_shoes(3)
	create_bugs(2)

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
