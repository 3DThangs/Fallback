extends Area2D
@export_enum("Up", "Down", "Both") var show : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if show == "Up":
		$AnimatedSprite2D.play("up")
		while true:
			position.y -= 1
			await get_tree().create_timer(0.5).timeout
			position.y += 1
			await get_tree().create_timer(0.5).timeout
	elif show == "Down":
		$AnimatedSprite2D.play("down")
		while true:
			position.y -= 1
			await get_tree().create_timer(0.5).timeout
			position.y += 1
			await get_tree().create_timer(0.5).timeout
	else:
		$AnimatedSprite2D.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#
#func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	#visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	$".".modulate.a = 0.25

func _on_area_2d_body_exited(body: Node2D) -> void:
	$".".modulate.a = 1
