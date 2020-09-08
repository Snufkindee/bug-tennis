extends KinematicBody2D
class_name Actor

export var velocity = Vector2(0,0)
export var gravity = 500
export var max_jumps = 1
export var jump_power = Vector2(50, -500)

var jump_unlocked = false
var collision_info

enum DIRECTION {
	right = 1,
	left = -1
}

export var current_direction = DIRECTION.right;
export var jump_key = "" # Assigned in editor

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	collision_info = move_and_collide(velocity * delta)
	
	check_collision()


func _input(event):
	if jump_unlocked and event.is_action_pressed(jump_key):
		velocity = jump_power * Vector2(current_direction, 1)
		jump_unlocked = false


func check_collision():
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
			
		
