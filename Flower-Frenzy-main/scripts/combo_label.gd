extends Label

var parent
var hit_count


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hit_count = parent.hit_count
	if hit_count == 0:
		self.visible = false
	else:
		self.visible = true
		text = "X" + str(hit_count)
