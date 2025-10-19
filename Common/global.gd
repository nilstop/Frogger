extends Node

var cell_size := 128.0
var screen_rect := Vector2(1280, 720)
var camera_x_divide := 3.0
var driveway_tiles : Array
var time := 0.000
var current_level := 0
var highscores := [0.0, 0.0, 0.0, 0.0]
