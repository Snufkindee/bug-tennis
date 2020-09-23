extends KinematicBody2D
class_name Ball

export var momentum = Vector2(0,0)
export var gravity = 500
onready var sprite = get_node("Sprite")

var collision_info

enum DIRECTION {
	right = 1,
	left = -1
}

export var current_direction = DIRECTION.right;

func _physics_process(delta: float) -> void:
	momentum.y += gravity * delta
	collision_info = move_and_collide(momentum * delta)
	check_collision()
	sprite.rotation += 0.2


func check_collision():
	# Collide with ground
	if collision_info and collision_info.normal.y == -1:
		momentum.y *= -1
		
	if collision_info and collision_info.normal.y == 1:
		momentum.y = 0
		
	# Collide with wall
	if collision_info and collision_info.normal.x != 0:
		momentum.x *= -1
		
		if current_direction == DIRECTION.right:
			current_direction = DIRECTION.left
		else:
			current_direction = DIRECTION.right
			
		
