extends Node

class_name  Walls

var walls_dict = {}
var top_left_corner: Vector2
var bottom_right_corner: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
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
	
	top_left_corner = Vector2(walls_dict["left"].position.x, walls_dict["top"].position.y)
	bottom_right_corner = Vector2(walls_dict["right"].position.x, walls_dict["bottom"].position.y)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
