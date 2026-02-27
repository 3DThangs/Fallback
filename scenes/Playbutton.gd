extends CanvasLayer

# Using typed variables for better performance
var mouse_in_pause: bool = false

# Pre-caching nodes so Godot doesn't have to "find" them repeatedly
@onready var pause_sprite: AnimatedSprite2D = $Area2D/AnimatedSprite2D
@onready var pause_area: Area2D = $Area2D

func _ready() -> void:
	pause_area.modulate.a = 0.5
	_update_sprite()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and mouse_in_pause:
			# Toggle pause state
			Global.paused = !Global.paused
			_update_sprite()
			get_viewport().set_input_as_handled()

func _update_sprite() -> void:
	if Global.paused:
		pause_sprite.play("pause")
	else:
		pause_sprite.play("play")

func _on_area_2d_mouse_entered() -> void:
	mouse_in_pause = true
	pause_area.modulate.a = 1.0

func _on_area_2d_mouse_exited() -> void:
	mouse_in_pause = false
	pause_area.modulate.a = 0.5
