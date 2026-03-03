extends Node2D
func _ready() -> void:
	while not Global.ad:
		await get_tree().create_timer(0.1).timeout
		$Button.visible = false
		$Label.visible = false
	
	$Label.visible = true
	await get_tree().create_timer(1).timeout
	$Label.visible = false
	$Button.visible = true
	$VideoStreamPlayer.play()
	while Global.ad:
		await get_tree().create_timer(0.1).timeout
	$VideoStreamPlayer.paused = true
	$VideoStreamPlayer.visible = false
	$Button.visible = false


func _on_button_pressed() -> void:
	Global.ad = false


func _on_video_stream_player_finished() -> void:
	$VideoStreamPlayer.play()


func _on_button_mouse_entered() -> void:
	await get_tree().create_timer(0.07).timeout
	$Button.position.x = randi_range(0, 640)
	$Button.position.y = randi_range(0, 360)
	
