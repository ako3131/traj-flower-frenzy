extends Label

var parent
var hit_count


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	self.visible = false

func update_combo():
	hit_count = parent.hit_count
	if hit_count == 0:
		self.visible = false
	else:
		self.visible = true
		text = "X" + str(hit_count)
		
func make_label_red():
	self.modulate = Color(1, 0, 0)
	
func make_label_white():
	self.modulate = Color(1, 1, 1)
