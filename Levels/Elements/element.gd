extends Node2D

@export var entity : PackedScene



@onready var timer: Timer = $Timer

## How far away from the start the element is. Cell is multiplied by 128 (grid cell size) to get desired the position.
@export var cell : int
@export var frequency_seconds : float
## The speed of which the entities moves through the lane.
@export var speed : int
## The width of the entities this element spawns.
@export var width_scale : float
## The direction the entities will head. -1 will make them head left and 1 right.
@export var direction : int

var inst_pos : Vector2
var inst_positions : Array = []

var left_corner = -Global.camera_x_divide * Global.cell_size - Global.cell_size/2.0 * width_scale
var right_corner = Global.screen_rect.x + Global.camera_x_divide * Global.cell_size + Global.cell_size/2.0 * width_scale


func _ready() -> void:
	if direction == -1:
		inst_pos.x = right_corner
		while inst_pos.x > left_corner:
			inst_positions.append(inst_pos)
			inst_pos.x -= frequency_seconds * speed
	else:
		inst_pos.x = left_corner
		while inst_pos.x < right_corner:
			inst_positions.append(inst_pos)
			inst_pos.x += frequency_seconds * speed
	instantiate(inst_pos)
	#set position using the exported cell variable, which is how far in the level the element is
	global_position = Vector2(Global.screen_rect.x/2.0, Global.screen_rect.y - cell * Global.cell_size + Global.cell_size / 2.0)

func instantiate(end_position):
	for n in inst_positions.size():
		var instance = entity.instantiate()
		instance.end_pos = end_position
		instance.global_position = inst_positions.get(n)
		instance.speed = speed
		instance.width_scale = width_scale
		instance.direction = direction
		add_child(instance)
