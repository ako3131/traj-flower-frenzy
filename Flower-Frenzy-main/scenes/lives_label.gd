extends Label

var parent
var max_lives = 3
var lives

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()

func update_lives():
	lives = parent.lives
	if lives >= max_lives:
		text = "O O O"
	elif lives == 2:
		text = "O O"
	elif lives == 1:
		text = "O"
	else:
		text = ""
		
	
