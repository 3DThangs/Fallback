class_name MainMenu
extends Control
var disabled : bool = false
var music_tmp = 1.00
var sfx_tmp = 1.00
var lobby_music = preload("res://assets/music/lobby.mp3")
var last_max_fps : int
var settings : bool = false

@onready var music_player = $AudioStreamPlayer

func _ready() -> void:
	if Input.is_action_pressed("move_right"):
		print("[DEBUG]: Mode enabled")
		Global.debug = true
		

	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	$"../../CanvasLayer".visible = false
	$".".visible = true
	$Settings.visible = false
	music_player.connect("finished", Callable(self, "_on_music_finished"))  # Connect the signal
	music_player.volume_linear = .277
	music_player.stream = lobby_music
	music_player.play()
	await get_tree().create_timer(0.1).timeout
	if Global.debug:
		_on_play_button_pressed()
	while not disabled:
		if Global.character == 0:
			$Settings/BG/AnimatedSprite2D.play("green")
			Global.character_name = "green"
		elif Global.character == 1:
			$Settings/BG/AnimatedSprite2D.play("blue")
			Global.character_name = "blue"
		elif Global.character == 2:
			$Settings/BG/AnimatedSprite2D.play("orange")
			Global.character_name = "orange"
		elif Global.character == 3:
			$Settings/BG/AnimatedSprite2D.play("pink")
			Global.character_name = "pink"
		elif Global.character == 4:
			$Settings/BG/AnimatedSprite2D.play("yellow")
			Global.character_name = "yellow"
		await get_tree().create_timer(0.1).timeout

func _on_play_button_pressed() -> void:
	if settings:
		deactivate(true)
		$"../../CanvasLayer".visible = true
		
	elif not disabled:
		deactivate(false)
		if not Global.debug:
			modulate = Color.BLACK
			$Settings/Label.visible = true
			await fade_out_music(music_player, 2.0)  # Wait for fade-out before deactivating
			
		music_player.stop()
		$Settings/Label.visible = false
		LevelManager.load_level(Global.level_to_begin)
		$"../../CanvasLayer".visible = true
		deactivate(true)
		

func _on_settings_button_pressed() -> void:
	if not disabled:
		$".".visible = false
		$Settings.visible = true

func _on_quit_button_pressed() -> void:
	if not disabled:
		get_tree().quit()

func deactivate(hide) -> void:
	disabled = true
	if hide:
		hide()
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)
	
func activate(mode) -> void:
	if mode == "settings":
		settings = true
		$"BG/MarginContainer/VBoxContainer/Play Button".text = "Resume"
		
	disabled = false
	modulate = Color.WHITE
	show()
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)

func fade_out_music(audio_player: AudioStreamPlayer, duration: float = 2.0):
	if not audio_player.playing:
		return  # Do nothing if the audio is already stopped
	
	var fade_steps = 75  # Number of steps for smooth fading
	var step_delay = duration / fade_steps  # Time between volume decreases
	var volume_decrement = (audio_player.volume_db / fade_steps) - 1 # Decrease amount per step

	for _i in range(fade_steps):
		await get_tree().create_timer(step_delay).timeout
		audio_player.volume_db += volume_decrement
	
	# Ensure volume is fully faded out before stopping
	#audio_player.volume_db = -80  # Almost silent
	audio_player.stop()



func _on_audio_stream_player_finished() -> void:
	music_player.stream = lobby_music
	music_player.play()

func _on_back_button_pressed() -> void:
	$".".visible = true
	$Settings.visible = false
	Global.sfx_volume = sfx_tmp
	Global.music_volume = music_tmp

func _on_music_value_changed(value: float) -> void:
	if value != 0:
		music_player.volume_linear = value + .1
	else: 
		music_player.volume_linear = 0
	music_tmp = value

func _on_sfx_value_changed(value: float) -> void:
	sfx_tmp = value

func _on_left_pressed() -> void:
	if (Global.character - 1) < 0:
		Global.character = 4
	else:
		Global.character -= 1

func _on_right_pressed() -> void:
	if (Global.character + 1) > 4:
		Global.character = 0
	else:
		Global.character += 1

func _on_spin_box_value_changed(value: float) -> void:
	Engine.max_fps = int(value)
	last_max_fps = int(value)

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		print("on")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		print("off")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_max_fps_toggled(toggled_on: bool) -> void:
	$Settings/BG/SpinBox.editable = toggled_on
	if not toggled_on:
		Engine.max_fps = 0
	else:
		Engine.max_fps = last_max_fps
