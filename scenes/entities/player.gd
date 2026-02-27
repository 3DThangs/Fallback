class_name Player
extends CharacterBody2D

@onready var player: CharacterBody2D = $"."
@export var cheats : bool = Global.debug
var old_speed
@export var speed : float = 300.0
@export var jump_force : float = -250.0
@export var jump_time : float = 0.25
@export var coyote_time : float = 0.075 #1 for flappy bird, 0.075
@export var gravity_multiplier : float = 2.0

@onready var music_player : AudioStreamPlayer = $Music
@onready var sfx_player : AudioStreamPlayer = $SFX

# for faster acceleration increase the value
@export var accelerationValue = 0.02
# for longer sliding time reduce the value
@export var slideValue = 0.01
@export var fullStopValue = 20
var is_slippery : bool = false

var use_music = true
var use_sfx = true
var in_latter
var disable_grav : bool = false
var disable_jump : bool = false
var currently_dead : bool = false
var colliding_objects = []
var songs = [
	preload("res://assets/music/01.mp3"),
	preload("res://assets/music/02.mp3"),
	preload("res://assets/music/03.mp3"),
	preload("res://assets/music/04.mp3"),
	preload("res://assets/music/05.mp3"),
	preload("res://assets/music/06.mp3"),
	preload("res://assets/music/07.mp3")
]
var last_song_index = -1  # Store the last song index to avoid repeats
var sfx = [
	preload("res://assets/sfx/jump.wav"),
	preload("res://assets/sfx/bounce.wav"),
	preload("res://assets/sfx/die.wav"),
	preload("res://assets/sfx/checkpoint.wav"),
	preload("res://assets/sfx/coin.mp3"),
	preload("res://assets/sfx/lock_box.wav"),
	preload("res://assets/sfx/teleport.mp3"),
	preload("res://assets/sfx/win.mp3"),
	preload("res://assets/sfx/button.mp3"),
	preload("res://assets/sfx/enemy_die.wav")
]

var is_jumping : bool = false
var jump_timer : float = 0
var coyote_timer : float = 0
var underworld : bool = false
var done : bool = false

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var can_control : bool = true
var respawn

var has_key : bool = false
var jumped : bool = false

func _ready() -> void:
	print($Music.volume_linear)
	print($SFX.volume_linear)
	$Music.volume_linear = Global.music_volume
	$SFX.volume_linear = Global.sfx_volume
	music_player.connect("finished", Callable(self, "_on_music_finished"))  # Connect the signal
	if use_music:
		play_random_song()  # Play the first song
	collect_lock_box(false)
	#if LevelManager.loaded_level:
	respawn = LevelManager.loaded_level.level_start_pos.global_position
	reset_player(true, false, true)
	#else:
		#print("Warning: LevelManager.loaded_level is null!")


func play_random_song():
	var new_index = randi() % songs.size()
	
	# Ensure we don't play the same song twice in a row
	while new_index == last_song_index:
		new_index = randi() % songs.size()

	last_song_index = new_index
	music_player.stream = songs[new_index]
	music_player.play()
	
func _physics_process(delta: float) -> void:
	sfx_player.volume_linear = remap(Global.sfx_volume, 0.00, 1.00, -80, -15)
	music_player.volume_linear = remap(Global.music_volume, 0.00, 1.00, -80, -10)

	if Input.is_action_just_pressed("pause"):
		Global.paused = not Global.paused
		
	if not Global.paused:
		if not can_control: return
		underworld = player.global_position.y >= 2000
		if is_on_floor():
			jumped = false
		# Add the gravity.
		if not is_on_floor() and not is_jumping and not disable_grav:
			velocity += get_gravity() * gravity_multiplier * delta
			coyote_timer += delta
		else:
			coyote_timer = 0
			
		if Input.is_action_pressed("fly") and cheats:
			disable_grav = true
			velocity.y = jump_force
		elif Input.is_action_just_released("fly") and cheats:
			disable_grav = false
		
		if Input.is_action_just_pressed("speed") and cheats:
			old_speed = speed
			speed = 1000
		elif Input.is_action_just_released("speed") and cheats:
			speed = old_speed
		# Handle jump.
		if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer < coyote_time) and not jumped and not disable_jump:
			jumped = true
			velocity.y = jump_force
			play_sfx("jump")
			is_jumping = true
			Global.player_moved = true
		
		elif Input.is_action_pressed("jump") and is_jumping and not disable_jump:
			velocity.y = jump_force
			Global.player_moved = true
			
		if is_jumping and Input.is_action_pressed("jump") and jump_timer < jump_time and not disable_jump:
			jump_timer += delta
			Global.player_moved = true
			
		else:
			is_jumping = false
			jump_timer = 0
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("move_left", "move_right")
		if is_slippery:
			sliding_movement(direction)
		else:
			normal_movement(direction)

		#Flip the sprite in correct direction
		if direction != 0:
			sprite_2d.flip_h = direction > 0
			
			
		handle_animation(direction)
		
		move_and_slide()
	
func sliding_movement(direction):
	if direction:
		velocity.x = lerp(velocity.x, direction * speed, accelerationValue)
		Global.player_moved = true
	else:
		velocity.x = lerp(velocity.x, 0.0, slideValue)
		
		if velocity.x < fullStopValue and velocity.x > -fullStopValue:
			velocity.x = 0
		
func normal_movement(direction):
	if direction:
		velocity.x = direction * speed
		Global.player_moved = true
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
func handle_animation(direction : float) -> void:
	if abs(direction) > 0.1 and is_on_floor():
		sprite_2d.play("%s - running" % Global.character_name)
	elif not is_on_floor():
		sprite_2d.play("%s - jump" % Global.character_name)
	else:
		sprite_2d.play("%s - idle" % Global.character_name)
		

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

func underworld_music() -> void:
	if underworld:
		await fade_out_music(music_player, 3.0)
		music_player.stream = preload("res://assets/music/underworld.mp3")
		music_player.play()
		


func handle_danger() -> void:
	if not currently_dead:
		$CollisionShape2D.disabled = true
		currently_dead = true
		play_sfx("die")
		can_control = false
		for i in range(0, 5):
			visible = not visible
			await get_tree().create_timer(0.1).timeout
			
		await get_tree().create_timer(0.6).timeout
		reset_player(true)
	
func reset_player(vars, death : bool = true, update : bool = false) -> void:
	if vars:
		speed = 300.0
		jump_force = -250.0
	if death:
		Global.powerups = []
		Global.powerup = null
		Global.death_count += 1
	if update:
		if Global.powerups.has("speed"):
			speed = 400
		elif Global.powerups.has("jump"):
			jump_force = -400
	global_position = respawn #I get "Error setting property 'global_position' with value of type Nil."
	visible = true
	can_control = true
	currently_dead = false
	$CollisionShape2D.disabled = false

func bounce(power : int) -> void:
	play_sfx("bounce")
	velocity.y = power # Default is -830

func play_sfx(effect : String) -> void:
	if use_sfx:
		if effect == "jump":
			sfx_player.stream = sfx[0]
		elif effect == "bounce":
			sfx_player.stream = sfx[1]
		elif effect == "die":
			sfx_player.stream = sfx[2]
		elif effect == "checkpoint":
			sfx_player.stream = sfx[3]
		elif effect == "coin":
			sfx_player.stream = sfx[4]
		elif effect == "lockbox":
			sfx_player.stream = sfx[5]
		elif effect == "teleport":
			sfx_player.stream = sfx[6]
		elif effect == "win":
			sfx_player.stream = sfx[7]
		elif effect == "click":
			sfx_player.stream = sfx[8]
		elif effect == "killed_enemy":
			sfx_player.stream = sfx[9]
		sfx_player.play()

func _on_music_finished() -> void:
	play_random_song()

func checkpoint(new_pos) -> void:
	respawn = new_pos
	play_sfx("checkpoint")

func collect_key() -> void:
	has_key = true
	Global.has_key = true
	play_sfx("coin")

func collect_lock_box(sound : bool = true) -> void:
	has_key = false
	Global.has_key = false
	Global.powerups.append(Global.powerup)
	if sound:
		play_sfx("lockbox")
	if Global.powerup == "speed":
		speed = 400
	elif Global.powerup == "jump":
		jump_force = -400
		

func teleport() -> void:
	can_control = false
	play_sfx("click")
	await get_tree().create_timer(1).timeout
	play_sfx("teleport")
	reset_player(false, false)
	
func win() -> void:
	Global.game_won = true
	can_control = false
	await fade_out_music(music_player,1.0)
	play_sfx("win")

func latter() -> void:
	in_latter = true
	disable_grav = true
	disable_jump = true
	velocity.y = 0
	while in_latter:
		while Input.is_action_pressed("up"):
			position.y -= 5
			await get_tree().create_timer(0.01).timeout
		while Input.is_action_pressed("down"):
			position.y += 5
			await get_tree().create_timer(0.01).timeout
		await get_tree().create_timer(0.1).timeout

func reset_latter() -> void:
	in_latter = false
	disable_grav = false
	disable_jump = false
	velocity.y = 0
	position.y -= 10
#	Later jumping fix
	Input.action_release("down")
	Input.action_release("up")

func collect_coin() -> void:
	Global.coin_count += 1
	play_sfx("coin")

func pipe(tele_to : Vector2, x_offset, y_offset) -> void:
	position.y = tele_to.y + y_offset
	position.x = tele_to.x + x_offset
	play_sfx("teleport")

func killed_enemy():
	play_sfx("killed_enemy")
	velocity.y -= 400

func set_x(x_pos : float):
	position.x = x_pos

func check_if_pinched():
	if colliding_objects.size() >= 2:
		handle_danger()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is Ball:
		colliding_objects.append(body)
		
	check_if_pinched()

func _on_area_2d_body_exited(body: Node2D) -> void:
	colliding_objects.erase(body)
