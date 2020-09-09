extends KinematicBody2D
class_name Actor

export var MAX_JUMP_TIME = 0.35

export var velocity = Vector2(0,0)
export var gravity = 4400
export var max_jumps = 1
export var jump_power = Vector2(450, -500)
export var hit_power = 900

var jump_unlocked = false
var ball_in_range = false
var collision_info
var can_hit = true
var curr_jump_time = 0
onready var ball = get_parent().get_node("Ball")

enum DIRECTION {
	right = 1,
	left = -1
}

export var current_direction = DIRECTION.right
export var jump_key = "" # Assigned in editor

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	collision_info = move_and_collide(velocity * delta)
	
	check_collision()
	check_jump_str(delta)

func _input(event):
	if jump_unlocked and event.is_action_pressed(jump_key):
		jump_unlocked = false
		
	if ball_in_range and event.is_action_pressed(jump_key):
		ball.velocity = Vector2(ball.transform.origin - transform.origin).normalized() * hit_power
		ball_in_range = false


func check_collision() -> void:
	# Collide with ground
	if collision_info and collision_info.normal.y == -1:
		velocity = Vector2(0,0)
		jump_unlocked = true
		
	if collision_info and collision_info.normal.y == 1:
		velocity.y = 0
		
	# Collide with wall
	if collision_info and collision_info.normal.x != 0:
		velocity.x *= -1
		
		if current_direction == DIRECTION.right:
			current_direction = DIRECTION.left
		else:
			current_direction = DIRECTION.right
			
		

func check_jump_str(delta: float) -> void:
	if jump_unlocked and Input.is_action_pressed(jump_key) and curr_jump_time <= MAX_JUMP_TIME:
		curr_jump_time += delta
		velocity = jump_power * Vector2(current_direction, 1)
		
	if Input.is_action_just_released(jump_key):
		curr_jump_time = 0

func _on_Range_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		ball_in_range = true

func _on_Range_body_exited(body: Node2D) -> void:
	if body.name == "Ball":
		ball_in_range = false
