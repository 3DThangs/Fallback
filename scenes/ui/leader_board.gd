extends CanvasLayer
class_name Leaderboard

func _ready() -> void:
	$".".visible = false
	while not Global.game_won:
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(2).timeout
	$Label.modulate.a = 0  # Normalize for alpha (0 to 1)
	$"Continue Button".modulate.a = 0
	$".".visible = true
	Global.game_time += float(Global.speedrun_time)
	var formatted_time = str("%.2f" % Global.game_time)
	$Label.text = "Completion time: %s" % Global.speedrun_time
	$Label2.text = "Total game time: %s" % formatted_time
	
	for i in range(0, 10, +1):  # Counts down from 10 to 1
		$Label.modulate.a = i / 10.0  # Normalize for alpha (0 to 1)
		$Label2.modulate.a = i / 10.0  # Normalize for alpha (0 to 1)
		$"Continue Button".modulate.a = i / 10.0  # Normalize for alpha (0 to 1)
		await get_tree().create_timer(0.09).timeout


func _on_continue_button_pressed() -> void:
	for i in range(10, 0, -1):  # Counts down from 10 to 1
		$Label.modulate.a = i / 10.0  # Normalize for alpha (0 to 1)
		$Label2.modulate.a = i / 10.0  # Normalize for alpha (0 to 1)
		$"Continue Button".modulate.a = i / 10.0  # Normalize for alpha (0 to 1)
		await get_tree().create_timer(0.09).timeout
		if (i / 10.0) < 0.2:
			Global.resume = true
			queue_free()
