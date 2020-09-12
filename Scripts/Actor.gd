extends KinematicBody2D
class_name Actor

export var MAX_JUMP_TIME = 0.35
export var FALL_FACTOR = 2
export var LOW_JUMP_FACTOR = 20
export var MOVEMENT_SPEED = 500
export var GRAVITY = 9.81
export var max_jumps = 1
export var hit_power = 900
export (float, 0, 1.0) var friction = 0.3
export (float, 0, 1.0) var acceleration = 0.25

var motion = Vector2()
var jump_unlocked = false
var ball_in_range = false
var can_hit = true
onready var ball = get_parent().get_node("Ball")

export var current_direction = 0

export var jump_key = "" # Assigned in editor
export var left_key = "" # Assigned in editor
export var right_key = "" # Assigned in editor
export var hit_key = "" # Assigned in editor
export var run_key = "" # Assigned in editor

func _physics_process(_delta: float) -> void:
	get_input()
	motion.y += 9.81
	motion = move_and_slide(motion, Vector2(0, -1))	
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = -600
	
func jump():
	if motion.y > 0:
		motion += Vector2.UP * -GRAVITY * FALL_FACTOR
	elif motion.y < 0 and Input.is_action_just_released("jump"):
		motion += Vector2.UP * -GRAVITY * LOW_JUMP_FACTOR

func get_input():
	current_direction = 0
	if Input.is_action_pressed(left_key):
		current_direction -= 1
	
	if Input.is_action_pressed(right_key):
		current_direction += 1
		
	if current_direction != 0:
		motion.x = lerp(motion.x, current_direction * MOVEMENT_SPEED, acceleration)
	else:
		motion.x = lerp(motion.x, 0, friction)
	

func _on_Range_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		ball_in_range = true

func _on_Range_body_exited(body: Node2D) -> void:
	if body.name == "Ball":
		ball_in_range = false
