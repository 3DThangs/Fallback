extends StaticBody2D
@onready var danger: Area2D = $Area2D
@onready var player_zone: Area2D = $Area2D2
@export var down_amount : float
var target_y
var smashing : bool = false
var origional_pos
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_player_zone_body_entered(body: Node2D) -> void:
	if body is Player and not smashing:
		smashing = true
		target_y = position.y + down_amount
		origional_pos = position.y
		await get_tree().create_timer(randf_range(0.5, 2)).timeout
		while position.y < target_y:
			position.y += 1
			await get_tree().create_timer(0.01).timeout
		await get_tree().create_timer(1).timeout
		while position.y > origional_pos:
			position.y -= 1
			await get_tree().create_timer(0.01).timeout
		position.y = origional_pos
		smashing = false
func _on_danger_body_entered(body: Node2D) -> void:
	if body is Player:
		body.handle_danger()
