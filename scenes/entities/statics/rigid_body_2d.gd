extends RigidBody2D

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):  # Press Enter or Space to test
		apply_impulse(Vector2(10, 0))  # Apply a small force
