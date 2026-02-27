extends RigidBody2D
class_name Ball

func _ready() -> void:
	$".".set_process(false)  # Disables _process()
	$".".set_physics_process(false)  # Disables _physics_process()



func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	$".".set_process(true)  # Disables _process()
	$".".set_physics_process(true)  # Disables _physics_process()
