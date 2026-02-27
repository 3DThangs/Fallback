extends Node2D

# Use an Enum for readability (0, 1, 2)
enum Mode { RIGHT = 1, MIDDLE = 2, LEFT = 3 }

@onready var animated_sprite_2d: AnimatedSprite2D = $Node2D/AnimatedSprite2D

@export_enum("Right:1", "Middle:2", "Left:3") var default_mode: int = 2
@export_enum("Left", "Middle", "Right", "None") var disable: int = 3 # 3 is None

var mode: int = 2:
	set(value):
		# This is a 'setter'. It runs automatically whenever 'mode' is changed.
		var old_mode = mode
		mode = clampi(value, 1, 3)
		if mode != old_mode:
			_handle_mode_logic(old_mode)

var player_in: bool = false

func _ready() -> void:
	z_index = 2
	mode = default_mode
	_update_visuals()

# Handle input only when player is inside and a key is pressed
func _unhandled_input(event: InputEvent) -> void:
	if not player_in:
		return
		
	if event.is_action_pressed("up"):
		mode += 1
	elif event.is_action_pressed("down"):
		mode -= 1

func _handle_mode_logic(prev_mode: int) -> void:
	# Check for disabled positions and skip them
	if mode == 3 and disable == 0: # Left disabled
		mode = 2 if prev_mode == 3 else 1
	elif mode == 2 and disable == 1: # Middle disabled
		mode = 3 if prev_mode == 1 else 1
	elif mode == 1 and disable == 2: # Right disabled
		mode = 2
		
	_update_visuals()

func _update_visuals() -> void:
	match mode:
		1: animated_sprite_2d.play("right")
		2: animated_sprite_2d.play("middle")
		3: animated_sprite_2d.play("left")

func _on_node_2d_body_entered(body: Node) -> void:
	if body is Player:
		player_in = true

func _on_node_2d_body_exited(body: Node) -> void:
	if body is Player:
		player_in = false
