extends Node2D

@export var hold_duration : float = 3.0 # Total time needed to hold
var hold_timer : float = 0.0

@onready var label : Label = $Label

func _ready() -> void:
	# Use relative movement instead of modifying absolute position if possible
	position.y -= 50
	label.visible = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("restart"):
		hold_timer += delta
		_update_restart_ui()
		
		if hold_timer >= hold_duration:
			_execute_restart()
	else:
		# Reset immediately if key is released
		if hold_timer > 0:
			hold_timer = 0.0
			label.visible = false

func _update_restart_ui() -> void:
	label.visible = true
	# Calculates remaining seconds (3, 2, 1...)
	var remaining = ceil(hold_duration - hold_timer)
	label.text = "Hold 'R' to restart: %s" % str(int(remaining))

func _execute_restart() -> void:
	# Reset timer so it doesn't trigger multiple times
	hold_timer = 0.0 
	label.visible = false
	
	LevelManager.unload_level()
	LevelManager.load_level(Global.current_level)
	# Note: action_release is usually not needed if the scene changes/reloads
