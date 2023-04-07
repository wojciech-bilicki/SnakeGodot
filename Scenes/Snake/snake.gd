extends Node2D

const BODY_SEGMENT_SIZE = 32

var body_fragments = []
var move_direction = Vector2.ZERO

var body_texture = preload("res://Scenes/Snake/Snake.png")
@onready var snake_parts: Node = $SnakeParts
@onready var timer = $Timer
@export var walls: Walls
var walls_dict
var food_spawner: FoodSpawner


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
	walls_dict = walls.walls_dict
	food_spawner = get_tree().get_first_node_in_group("food_spawner") as FoodSpawner
	

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
	var previous_head_position = body_fragments[0].position
	var new_head_position = previous_head_position + move_direction * BODY_SEGMENT_SIZE
	
	var wall_collision = check_wall_collision(new_head_position)
	if wall_collision == null:
		move_to_position(new_head_position)
	else:
		var position_collision = get_position_after_collision(wall_collision, new_head_position)
		move_to_position(position_collision)
			
	#check for snake colliding with itself
	var snake_collision = check_snake_collision()
	if(snake_collision):
		print("GAME OVER") 
	
	#food collision
	if new_head_position == food_spawner.food_position:
		food_spawner.destroy_food()
		food_spawner.spawn_food()
		add_body_segment()
	
	
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

	var last_element = body_fragments.pop_back()
	body_fragments.insert(0, last_element)
		
	body_fragments[0].position = new_position
	position = new_position
	
func add_body_segment():
	var new_segment = Sprite2D.new()
	new_segment.texture = body_texture
	snake_parts.add_child(new_segment)
	new_segment.position = body_fragments[-1].position - move_direction * BODY_SEGMENT_SIZE
	body_fragments.append(new_segment)

func check_snake_collision():
	if(body_fragments.filter(func (fragment): return fragment.position == position )):
		return true
	return false
