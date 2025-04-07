class_name Hitstop
extends Node

signal hitstop_completed

@export var hitstop_duration: float = 0.1  # Reduced duration for better feel
@export var time_scale_factor: float = 0.5  # How much to slow down time (0.2 = 20% speed)

var is_active: bool = false
var timer: Timer
var original_time_scale: float = 1.0
var affected_nodes = []

func _ready() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.process_callback = Timer.TIMER_PROCESS_IDLE

# Get all nodes that should be affected by hitstop
func get_affected_nodes() -> Array:
	var root = get_tree().root
	var current_scene = root.get_child(root.get_child_count() - 1)
	
	# Get all visual nodes but exclude audio nodes
	var nodes = []
	var queue = [current_scene]
	
	while queue.size() > 0:
		var node = queue.pop_front()
		
		# Skip audio-related nodes
		if not (node is AudioStreamPlayer or node is AudioStreamPlayer2D or node is AudioStreamPlayer3D):
			if node is CanvasItem or node is Node3D:
				nodes.append(node)
		
		for child in node.get_children():
			queue.append(child)
	
	return nodes

func start() -> void:
	if is_active:
		return
	
	# Use time dilation instead of disabling nodes
	is_active = true
	affected_nodes = get_affected_nodes()
	
	# Store original time scale and slow down time
	original_time_scale = Engine.time_scale
	Engine.time_scale = time_scale_factor
	
	# Use a timer that's not affected by time_scale
	timer.wait_time = hitstop_duration
	timer.timeout.connect(_on_hitstop_timer_timeout, CONNECT_ONE_SHOT)
	timer.start()

func _on_hitstop_timer_timeout() -> void:
	end()

# Restore normal processing
func end() -> void:
	if is_active:
		# Restore original time scale
		Engine.time_scale = original_time_scale
		
		# Clear stored data
		affected_nodes.clear()
		
		is_active = false
		emit_signal("hitstop_completed")
