extends StaticBody2D

@export var tilt_speed: float = 5
@export var max_tilt: float = 1  # Radians
@export var reset_speed: float = 3
var in_zone : bool = false
var target_rotation = 0.0

func _on_area_2d_body_entered(body):
	if body is Player:
		in_zone = true
		while in_zone:
			#if Input.is_action_pressed("jump"):
				#body.velocity.y = body.jump_force
			var direction = sign(body.global_position.x - global_position.x)
			target_rotation = direction * max_tilt
			await get_tree().create_timer(0.1).timeout

func _on_area_2d_body_exited(body):
	if body is Player:
		in_zone = false
		body.disable_jump = false
		target_rotation = 0.0  # Reset rotation when player leaves

func _process(delta):
	rotation = lerp(rotation, target_rotation, tilt_speed * delta)
