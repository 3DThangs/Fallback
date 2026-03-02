extends Node
signal game_paused
signal game_played

var offset_time = "0.00"
var speedrun_time = "0.00"
var game_time : float = 0.00
var game_won : bool = false
var current_level
var player_moved : bool = false
var coin_count : int
var powerup
var has_key : bool = false
var death_count : int = 0

var debug : bool = false
var level_to_begin = 1

var sfx_volume : float = 0.316
var music_volume : float = 0.177

var paused: bool = false:
	set(value):
		paused = value
		if paused:
			pause_game()
		else:
			play_game()
	get:
		return paused
		
var powerups := []

var resume : bool = false
var startup : bool = true
var character : int = 0
var character_name : String = "green"
var reset_level : bool = false

func pause_game():
	emit_signal("game_paused")
	
func play_game():
	emit_signal("game_played")
