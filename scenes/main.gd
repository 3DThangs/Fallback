extends Node

@export var avaliable_levels : Array[LevelData]
@onready var _2d_scene: Node2D = $"2DScene"
var player_instance

func _ready() -> void:
	LevelManager.main_scene = _2d_scene
	LevelManager.levels = avaliable_levels
	while true:
		if Global.game_won and (Global.resume):
			Global.startup = false
			Global.game_won = false
			Global.resume = false
			LevelManager.load_level(Global.current_level + 1)
			Global.speedrun_time = 0
			
		await get_tree().create_timer(0.1).timeout
