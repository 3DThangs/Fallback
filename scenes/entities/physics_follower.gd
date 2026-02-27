extends RigidBody2D

@export var follow_target: CharacterBody2D
@export var follow_speed: float = 10.0
@export var follow_strength: float = 0.1  # Lower = looser following, higher = tighter

func _physics_process(delta):
	if follow_target:
		var target_position = follow_target.global_position
		#var direction = (target_position - global_position) * follow_strength
		#apply_central_impulse(direction * follow_speed)
		global_position = target_position
