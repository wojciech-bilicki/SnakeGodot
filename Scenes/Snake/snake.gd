extends CharacterBody2D

const BODY_SEGMENT_SIZE = Vector2(16, 16)
const MAX_SPEED = 64
var acceleration = 500

var body_fragments = []
var move_direction = Vector2.ZERO

var body_texture = preload("res://Scenes/Snake/Snake.png")
@onready var snake_parts: Node = $SnakeParts
@onready var timer = $Timer

func _ready():
	var head = Sprite2D.new()
	head.position = Vector2(0,0)
	head.scale = Vector2(1,1)
	snake_parts.add_child(head)
	body_fragments.append(head)
	timer.timeout.connect(on_timeout)

func _input(event):
	# Handle user input to change the move direction
	if event.is_action_pressed("ui_right") and move_direction.x != -1:
		move_direction = Vector2(1, 0)
	elif event.is_action_pressed("ui_left") and move_direction.x != 1:
		move_direction = Vector2(-1, 0)
	elif event.is_action_pressed("ui_up") and move_direction.y != 1:
		move_direction = Vector2(0, -1)
	elif event.is_action_pressed("ui_down") and move_direction.y != -1:
		move_direction = Vector2(0, 1)
		
		
func on_timeout():
	var new_head_position = body_fragments[0].position + move_direction * BODY_SEGMENT_SIZE.x
	move_to_position(new_head_position)
	
func move_to_position(new_position):
	# Get the character's current position
	var current_pos = position
	
	# Calculate the direction vector to the target position
	var direction = new_position - current_pos
	
	# Normalize the direction vector
	direction = direction.normalized()
	
	velocity += direction * get_process_delta_time()
	
	# Limit the character's velocity to the maximum speed
	
	# Move the character in the direction of the target position
	move_and_slide()
