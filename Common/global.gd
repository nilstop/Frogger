extends Node

var cell_size := 128.0
var screen_rect := Vector2(1280, 720)
var camera_x_divide := 3.0
var driveway_tiles : Array
var time := 0.000
var current_level := 0
var highscores := [-1.0, -1.0, -1.0, -1.0]

const PATH_TO_LEVELS := "res://Level/Levels/"

func inst(scene):
	var instance = load(scene).instantiate()
	get_tree().get_first_node_in_group("world").add_child(instance)

func quit_to_menu():
	get_tree().get_first_node_in_group("main_menu").appear()
	get_tree().get_first_node_in_group("level").queue_free()

func switch(scene):
	get_tree().get_first_node_in_group("level").queue_free()
	await get_tree().process_frame
	inst(scene)
	current_level += 1
