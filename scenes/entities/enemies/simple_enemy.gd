extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 100

var direction: Vector2 = Vector2.LEFT  # Moving left initially
var alive : bool = true
var collided : bool = false

func _ready() -> void:
	animated_sprite_2d.play("walk")
			
func _physics_process(delta):
	velocity.y += get_gravity().y * delta  # Apply gravity
	velocity.x = direction.x * speed  # Keep moving sideways
	
	move_and_slide()
	
	# Reverse direction when hitting a wall
	if is_on_wall():
		direction = -direction
		
	if direction.x == -1:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true

func deactivate() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)

func _on_top_body_entered(body: Node2D) -> void:
	if body is Player and alive:
		alive = false
		body.killed_enemy()
		deactivate()
		animated_sprite_2d.play("die")
		await get_tree().create_timer(0.5).timeout
		visible = false
		$CollisionShape2D.disabled = true
		$side_a.monitoring = false
		$side_b.monitoring = false
		$top.monitoring = false
	


func _on_side_b_body_entered(body: Node2D) -> void:
	if alive:
		if body is Player:
			collided = true
			body.handle_danger()
			$side_b.monitoring = false

func _on_side_a_body_entered(body: Node2D) -> void:
	if alive:
		if body is Player:
			collided = true
			body.handle_danger()
			$side_a.monitoring = false
