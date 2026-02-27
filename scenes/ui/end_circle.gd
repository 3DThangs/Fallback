extends Sprite2D
var scale_float : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".z_index = 2
	scale = Vector2(0.4, 0.4)
	visible = false
	while Global.game_won:
		await get_tree().create_timer(0.1).timeout
	
	while not Global.game_won:
		await get_tree().create_timer(0.1).timeout
	visible = true
	while $".".scale >= Vector2(0.07, 0.07):
		scale_float -= 0.01
		$".".scale = Vector2(scale_float, scale_float)
		await get_tree().create_timer(0.01).timeout
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
