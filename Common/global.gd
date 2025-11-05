extends Node

var cell_size := 128.0
var screen_rect := Vector2(1280, 720)
var camera_x_divide := 3.0
var driveway_tiles : Array
var time := 0.000
var current_level := -1
var highscores := [-1.0, -1.0, -1.0, -1.0]
var level_width := 1

const PATH_TO_LEVELS := "res://Level/Levels/"
@onready var loading_timer: Timer = get_tree().get_first_node_in_group("loadingtimer")
@onready var load_label: Label = get_tree().get_first_node_in_group("loadlabel")

func _ready() -> void:
	loading_timer.connect("timeout", done_loading)

func inst(scene):
	var instance = load(scene).instantiate()
	get_tree().get_first_node_in_group("world").add_child(instance)

func quit_to_menu():
	Global.current_level = -1
	time = 0.0
	get_tree().get_first_node_in_group("main_menu").appear()
	get_tree().get_first_node_in_group("level").queue_free()

func switch(scene):
	if load(scene) != null:
		time = 0.0
		get_tree().get_first_node_in_group("level").queue_free()
		await get_tree().process_frame
		inst(scene)
		load_level()
		current_level += 1

func get_level_highscore():
	return highscores[current_level - 1]

func load_level():
	Engine.time_scale = 3.4
	load_label.show()
	loading_timer.start()

func done_loading():
	Engine.time_scale = 1
	load_label.hide()
