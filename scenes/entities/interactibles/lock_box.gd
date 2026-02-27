extends Area2D
var power
var used : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if not used:
		if body is Player and body.has_key:
			power = randi_range(0, 1)
			print(power)
			if power == 0:
				$Label.text = "+ speed"
				Global.powerup = "speed"
				body.collect_lock_box()
			elif power == 1:
				$Label.text = "+ jump"
				Global.powerup = "jump"
				body.collect_lock_box()
				
			for i in range(0, 2):
				hide()
				await get_tree().create_timer(0.2).timeout
				show()
				await get_tree().create_timer(0.2).timeout
			
			used = true
			deactivate()

func deactivate() -> void:
	hide()
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)
