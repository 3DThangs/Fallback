extends Node2D
@onready var label: Label = $Label

@export var custom_text : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	label.text = custom_text
	label.visible = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	label.visible = false
