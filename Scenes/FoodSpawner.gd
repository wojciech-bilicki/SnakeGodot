extends Node
class_name FoodSpawner

@export var walls: Walls
@export var food_scene: PackedScene

var food_position: Vector2
var food

const BODY_SEGMENT_SIZE = 32

func spawn_food(snake_parts: Array):
	food = food_scene.instantiate()
	var x_pos = round(randi_range(walls.top_left_corner.x, walls.bottom_right_corner.x) / BODY_SEGMENT_SIZE) * BODY_SEGMENT_SIZE
	var y_pos = round(randi_range(walls.top_left_corner.y, walls.bottom_right_corner.y) /BODY_SEGMENT_SIZE) * BODY_SEGMENT_SIZE

	food_position = get_food_position()
	while snake_parts.any(func (part): part.position == food_position):
		food_position = get_food_position()

	add_child(food)
	food.position = food_position

func get_food_position() -> Vector2:
	var x_pos = round(randi_range(walls.top_left_corner.x, walls.bottom_right_corner.x) / BODY_SEGMENT_SIZE) * BODY_SEGMENT_SIZE
	var y_pos = round(randi_range(walls.top_left_corner.y, walls.bottom_right_corner.y) /BODY_SEGMENT_SIZE) * BODY_SEGMENT_SIZE

	return Vector2(x_pos, y_pos)


func destroy_food():
	if food != null:
		food.queue_free()
