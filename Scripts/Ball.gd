extends KinematicBody2D
class_name Ball

export var velocity = Vector2(0,0)
export var gravity = 500

var collision_info

enum DIRECTION {
	right = 1,
	left = -1
}

export var current_direction = DIRECTION.right;

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	collision_info = move_and_collide(velocity * delta)
	
	check_collision()


func check_collision():
	# Collide with ground
	if collision_info and collision_info.normal.y == -1:
		velocity.y *= -1
		
	if collision_info and collision_info.normal.y == 1:
		velocity.y = 0
		
	# Collide with wall
	if collision_info and collision_info.normal.x != 0:
		velocity.x *= -1
		
		if current_direction == DIRECTION.right:
			current_direction = DIRECTION.left
		else:
			current_direction = DIRECTION.right
			
		
