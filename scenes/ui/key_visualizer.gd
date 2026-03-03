extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	while true:
		visible = Global.has_key
		await get_tree().create_timer(0.1).timeout
