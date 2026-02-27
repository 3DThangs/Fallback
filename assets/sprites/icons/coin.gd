extends Area2D

var collected : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animate_float()
	animation_player.play("spin")

func _on_body_entered(body: Node2D) -> void:
	if (body is Player) and not collected:
		body.collect_coin()
		deactivate()

func deactivate() -> void:
	collected = true
	visible = false
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)
	
func animate_float() -> void:
	while true:
		position.y -= 1
		await get_tree().create_timer(0.5).timeout
		position.y += 1
		await get_tree().create_timer(0.5).timeout
