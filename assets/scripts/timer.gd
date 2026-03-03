extends CanvasLayer

var fmt_tmp 
var time = Global.speedrun_time

func reset_to_zero():
	time = "0.00"
	Global.speedrun_time = "0.00"
	$Label.text = "0.00"
	Global.offset_time = "0.00"
func _ready() -> void:
	$Label.text = "0.00"
	Global.offset_time = Global.speedrun_time
	
func _physics_process(delta):
	if (not Global.game_won) and Global.player_moved and not Global.paused:
		time = float(time) + delta
		update_ui()
	
func update_ui():
	# Format time with two decimal places
	fmt_tmp = time - float(Global.offset_time)
	var formatted_time = str("%.2f" % fmt_tmp)
	
	#var decimal_index = formatted_time.find(".")
	#
	#if decimal_index > 0:
		#formatted_time = formatted_time.left(decimal_index + 3)  # Take only two decimal places

	Global.speedrun_time = formatted_time

	$Label.text = formatted_time
