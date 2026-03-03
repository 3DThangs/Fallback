extends Node2D
@export_enum("Red", "Blue") var color : String = "Red"

func _ready() -> void:
	if color == "Red":
		$AnimationPlayer.play("FadeRed")
	elif color == "Blue":
		$AnimationPlayer.play("FadeBlue")
