extends StaticBody2D
@export var teleport_to : StaticBody2D
@export var y_offset : int = -30
@export var x_offset : int = 0
var still_waiting : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".z_index = 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		still_waiting = true
		await wait_for_action("down")
		if still_waiting:
			body.set_x(global_position.x)
			$CollisionShape2D.disabled = true
			await get_tree().create_timer(0.2).timeout
			body.pipe(teleport_to.global_position, x_offset, y_offset)
			$CollisionShape2D.disabled = false


func wait_for_action(action_name: String):
	await get_tree().create_timer(0.1).timeout  # Prevent freezing
	await get_tree().process_frame  # Ensure the game doesn't hang
	while true:
		await get_tree().process_frame  # Wait for the next frame
		if Input.is_action_just_pressed(action_name):
			return


func _on_area_2d_body_exited(_body: Node2D) -> void:
	still_waiting = false
