extends StaticBody2D
@export var trigger : Node2D
@export var left_position : Node2D
@export var right_position : Node2D
@export var steps : float = 1

var average_x
var heading_to : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	average_x = ((right_position.global_position.x + left_position.global_position.x) / 2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	await get_tree().create_timer(0.1).timeout
	if trigger.mode == steps:
		heading_to = 1
		while global_position.x < right_position.global_position.x:
			position.x += steps
			await get_tree().create_timer(0.1).timeout
		global_position.x = right_position.global_position.x
	elif trigger.mode == 2 or trigger.mode == 1:
		if heading_to == 1:
			while global_position.x > average_x:
				position.x -= steps
				await get_tree().create_timer(0.1).timeout
		elif heading_to == 3:
			while global_position.x < average_x:
				position.x += steps
				await get_tree().create_timer(0.1).timeout
		heading_to = 2
	elif trigger.mode == 3:
		heading_to = 3
		while global_position.x > left_position.global_position.x:
			position.x -= steps
			await get_tree().create_timer(0.1).timeout
		global_position.x = left_position.global_position.x
