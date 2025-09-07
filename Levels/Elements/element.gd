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

func _ready() -> void:
	timer.wait_time = frequency_seconds
	timer.start()
	#set position using the exported cell variable, which is how far in the level the element is
	global_position = Vector2(Global.screen_rect.x/2.0, Global.screen_rect.y - cell * Global.cell_size + Global.cell_size / 2.0)

func _on_timer_timeout() -> void:
	instantiate()

func instantiate():
	var instance = entity.instantiate()
	instance.speed = speed
	instance.width_scale = width_scale
	instance.direction = direction
	add_child(instance)
