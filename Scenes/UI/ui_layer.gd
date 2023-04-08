extends CanvasLayer

@export var snake: Snake

var button_container: HBoxContainer
@onready var label: Label = $GameOverLabel
@onready var restart_button: Button = $%Restart
@onready var quit_button: Button = $%Quit
@onready var points_label:Label = $PointsLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	snake.on_game_over.connect(on_game_over)
	snake.on_point_scored.connect(on_point_scored)
	button_container = get_node("ButonContainer")
	restart_button.pressed.connect(on_restart_button_pressed)
	quit_button.pressed.connect(on_quit_button_pressed)

func on_game_over():
	button_container.visible = true
	label.visible = true
	print("GAME OVER UI")

func on_restart_button_pressed():
	get_tree().reload_current_scene()

func on_point_scored(points):
	points_label.text = "Points: %d" % points

func on_quit_button_pressed():
		get_tree().quit()

