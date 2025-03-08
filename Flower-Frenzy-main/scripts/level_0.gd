extends Node2D

@onready var character = $coco
var shoe_scene = preload("res://scenes/shoe_monster.tscn")
var bug_scene = preload("res://scenes/bug_monster.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	character.position = Vector2(-700, 719)
	
	create_shoes(1)
	create_bugs(1)

func create_shoes(count: int):
	var x_change = 70
	var y_change = -50
	var x = 1132
	var y = 628
	for i in range(count):
		var shoe = shoe_scene.instantiate()
		add_child(shoe)
		shoe.position = Vector2(x + (x_change * i), y + (y_change * i))
		#shoe.scale = Vector2(2,2)
	
func create_bugs(count: int):
	var x_change = 100
	var y_change = 0
	var x = 522
	var y = 700
	for i in range(count):
		var bug = bug_scene.instantiate()
		add_child(bug)
		bug.position = Vector2(x + (x_change * i), y + (y_change * i))
		#bug.scale = Vector2(2,2)
