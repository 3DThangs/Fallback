extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var extended : bool = false

var sfx = preload("res://assets/sfx/checkpoint.wav")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("idle_down")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if not extended and (body is Player):
		body.win()
		extended = true
		animated_sprite_2d.play("idle_up")
		position.y -= 9
