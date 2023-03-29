extends Node2D

const BODY_SEGMENT_SIZE = 32

var body_fragments = []
var move_direction = Vector2.ZERO

var body_texture = preload("res://Scenes/Snake/Snake.png")
@onready var snake_parts: Node = $SnakeParts
@onready var timer = $Timer
var walls_dict = {}

enum CollisionDirection {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT
}

func _ready():
	var head = Sprite2D.new()
	head.position = Vector2(0,0)
	head.scale = Vector2(1,1)
	head.texture = body_texture
	snake_parts.add_child(head)
	body_fragments.append(head)
	timer.timeout.connect(on_timeout)
	
	var walls = get_tree().get_nodes_in_group("walls")
	#initiate walls
	for wall in walls:
		var wall_node = wall as Node2D
		if wall_node.position.x < 0:
			walls_dict["left"] = wall_node
		elif wall_node.position.x > 0:
			walls_dict["right"] = wall_node
		elif wall_node.position.y < 0:
			walls_dict["top"] = wall_node
		elif wall_node.position.y > 0:
			walls_dict["bottom"] = wall_node

func _input(event):
	# Handle user input to change the move direction
	if (event.is_action_pressed("ui_right") || event.is_action_pressed("right")) and move_direction.x != -1:
		move_direction = Vector2.RIGHT
	elif (event.is_action_pressed("ui_left") or event.is_action_pressed("left")) and move_direction.x != 1:
		move_direction = Vector2.LEFT
	elif (event.is_action_pressed("ui_up") or event.is_action_pressed("up")) and move_direction.y != 1:
		move_direction = Vector2.UP
	elif (event.is_action_pressed("ui_down") or event.is_action_pressed("down")) and move_direction.y != -1:
		move_direction = Vector2.DOWN
		
		
func on_timeout():
	var new_head_position = body_fragments[0].position + move_direction * BODY_SEGMENT_SIZE
	
	var wall_collision = check_wall_collision(new_head_position)
	print(wall_collision)
	if wall_collision == null:
		move_to_position(new_head_position)
	else:
		var position_collision = get_position_after_collision(wall_collision, new_head_position)
		
		move_to_position(position_collision)
	
	
func get_position_after_collision(wall_collision, head_position):
	if (wall_collision == CollisionDirection.LEFT or wall_collision == CollisionDirection.RIGHT) && head_position.y <= 0:
		move_direction = Vector2.DOWN
	elif (wall_collision == CollisionDirection.LEFT or wall_collision == CollisionDirection.RIGHT) && head_position.y > 0:
		move_direction = Vector2.UP
	if (wall_collision == CollisionDirection.TOP || wall_collision == CollisionDirection.BOTTOM) && head_position.x <= 0:
		move_direction = Vector2.RIGHT 
	if (wall_collision == CollisionDirection.TOP || wall_collision == CollisionDirection.BOTTOM) && head_position.x > 0:
		move_direction = Vector2.LEFT

	return body_fragments[0].position + move_direction * BODY_SEGMENT_SIZE
	
func check_wall_collision(head_position):
	if head_position.x == walls_dict["left"].position.x && move_direction == Vector2.LEFT:
		return CollisionDirection.LEFT
	if head_position.x == walls_dict["right"].position.x && move_direction == Vector2.RIGHT:
		return CollisionDirection.RIGHT
	if head_position.y == walls_dict["top"].position.y and move_direction == Vector2.UP:
		return CollisionDirection.TOP
	if head_position.y  == walls_dict["bottom"].position.y and move_direction == Vector2.DOWN:
		return CollisionDirection.BOTTOM
	
func move_to_position(new_position):
	body_fragments[0].position = new_position
	position = new_position
