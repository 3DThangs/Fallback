extends Area2D

# Signal for body entering this area
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.handle_danger()
