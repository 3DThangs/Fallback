class_name Level
extends Node

@export var level_id : int
@export var level_start_pos : Node2D
@export var hints : bool = false
var level_data : LevelData

func _ready() -> void:
	$Sprite2D.visible = Global.debug
	level_data = LevelManager.get_level_data_by_id(level_id)
	Global.game_won = false
	Global.death_count = 0
	Global.coin_count = 0
	Global.has_key = false
	Global.player_moved = false
	if Global.debug:
		pass
	
	if $Node2D:
		$Node2D.visible = hints
		
#If you get a NIL error, it is because `Level Start Pos` is empty
