extends StaticBody2D
@export var trigger : Node2D
@export var left_position : Node2D
@export var right_position : Node2D
@export var max_speed: float = 200.0 

var target_x: float = 0.0
var average_x
var smoothing : float = 0.1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	average_x = ((right_position.global_position.x + left_position.global_position.x) / 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# 1. Determine the target based on the mode
	match trigger.mode:
		1:
			target_x = right_position.global_position.x
		2:
			target_x = average_x
		3:
			target_x = left_position.global_position.x
			
	# 2. Move towards that target smoothly using move_toward
	#global_position.x = lerp(global_position.x, target_x, smoothing)
	
	global_position.x = move_toward(global_position.x, target_x, max_speed * delta)
