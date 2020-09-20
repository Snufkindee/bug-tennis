extends KinematicBody2D
class_name Actor

# Movement
const MOVEMENT_SPEED = 300
const MAX_SPEED = 500
const DASH_SPEED = 2000
export (float, 0, 1.0) var friction = 0.25
export (float, 0, 1.0) var acceleration = 0.25
export var set_dashing = false

var motion = Vector2()
var current_speed = 0
var current_direction = 0
var running = false
var dash = false

# Jumping
const MAX_JUMP_TIME = 1
const FALL_FACTOR = 1
const LOW_JUMP_FACTOR = 1

var max_jumps = 1
var jump_force = 800
var jump_unlocked = false

# Hitting
var hit_power = 900
var ball_in_range = false
var can_hit = true

# Physics
var GRAVITY = 30

# Nodes
onready var ball = get_parent().get_node("Ball")
onready var animation_player = get_node("Sprite/AnimationPlayer")
onready var animation_tree = get_node("Sprite/AnimationTree")
onready var sprite = get_node("Sprite")

# Buttons
export var jump_key = "" # Assigned in editor
export var left_key = "" # Assigned in editor
export var right_key = "" # Assigned in editor
export var hit_key = "" # Assigned in editor
export var run_key = "" # Assigned in editor

func _physics_process(_delta: float) -> void:
	
	animate_aiming_angle()
	get_input()
	get_jump()
	
	motion.y += GRAVITY
	motion = move_and_slide(motion, Vector2(0, -1))
	
func get_jump():
	if motion.y > 0:
		motion += Vector2.UP * -GRAVITY * FALL_FACTOR
	elif motion.y < 0 and !Input.is_action_pressed("jump"):
		motion += Vector2.UP * -GRAVITY * LOW_JUMP_FACTOR
		
	if is_on_floor():
		#set_animation("PlayerIdle")
		if Input.is_action_just_pressed("jump"):
			motion.y -= jump_force
			#set_animation("PlayerJump")

func get_input():
	current_direction = 0
	if Input.is_action_pressed(left_key):
		#sprite.set_scale(Vector2(-1,1))
		current_direction = -1
	
	if Input.is_action_pressed(right_key):
		#sprite.set_scale(Vector2(1,1))
		current_direction = 1
		
	if current_direction != 0:
		get_run()
		if !dash:
			motion.x = lerp(motion.x, current_direction * current_speed, acceleration)
		else:
			motion.x = lerp(motion.x, current_direction * DASH_SPEED, 1)
			dash = false
	else:
		motion.x = lerp(motion.x, 0, friction)
		
	get_hit_input()
	
func get_hit_input():
	if Input.is_action_pressed("hit"):
		animation_tree.set("parameters/Swing/active", true)
	if ball_in_range and Input.is_action_pressed("hit") and !running:
		ball.momentum = Vector2(ball.transform.origin - transform.origin).normalized() * hit_power
		ball_in_range = false
		
func get_run():
	current_speed = MOVEMENT_SPEED
	if !set_dashing:
		if Input.is_action_pressed("run"):
			current_speed = MAX_SPEED
			running = true
		else:
			running = false
	else:
		if Input.is_action_just_pressed("run"):
			dash = true
	
		
func set_animation(animation):
	animation_player.play(animation)
	

func animate_aiming_angle():
	var aim_angle = Vector2()
	var flip_dir
	aim_angle = transform.origin.angle_to_point(ball.transform.origin) / PI
	if aim_angle >= 0.5: #Directions between right & up
		flip_dir = 1
		aim_angle = 1.5 - aim_angle
	elif aim_angle < -0.5: #Directions between right & down
		flip_dir = 1
		aim_angle = -0.5 - aim_angle
	elif aim_angle >= 0 and aim_angle < 0.5: #Directions between left & up
		flip_dir = -1
		aim_angle = 0.5 + aim_angle
	elif aim_angle < 0 and aim_angle >= -0.5: #Directions between left & down
		flip_dir = -1
		aim_angle = 0.5 + aim_angle
	sprite.set_scale(Vector2(flip_dir,1))
	animation_tree.set("parameters/Aim_grounded/seek_position", aim_angle)

func _on_Range_body_entered(body: Node2D) -> void:
	if body.name == "Ball":
		ball_in_range = true

func _on_Range_body_exited(body: Node2D) -> void:
	if body.name == "Ball":
		ball_in_range = false
