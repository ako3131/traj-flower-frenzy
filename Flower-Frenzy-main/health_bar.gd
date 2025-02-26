extends ProgressBar

var parent
var max_val
var min_val = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	max_val = parent.max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.value = parent.health
	if parent.health != max_val:
		self.visible = true
		if parent.health == min_val:
			self.visible = false
	else:
		self.visible = false
