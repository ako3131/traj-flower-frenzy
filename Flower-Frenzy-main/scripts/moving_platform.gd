extends Path2D

@export var speed := 200.0
@export var easing := -1.56

@onready var path: PathFollow2D = $PathFollow2D
@onready var animation := $AnimationPlayer

var direction := -1  # ← Start moving in reverse

func _ready() -> void:
	animation.play("move")
	path.progress_ratio = 1.0  # ← Start from end of path

func _process(delta: float) -> void:
	var curve_length = curve.get_baked_length()
	var new_progress = path.progress + speed * delta * direction

	var ratio = new_progress / curve_length
	if ratio >= 1.0:
		direction = -1
	elif ratio <= 0.0:
		direction = 1

	path.progress = move_toward(path.progress, new_progress, abs(speed * delta) ** (1 + easing))
