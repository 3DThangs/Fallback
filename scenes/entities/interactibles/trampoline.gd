extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var power : int = -830
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.bounce(power)
		animation_player.play("bounce")
		#await get_tree().create_timer(1).timeout



func _on_body_exited(body: Node2D) -> void:
	await get_tree().create_timer(0.01).timeout
	animation_player.play("down")
