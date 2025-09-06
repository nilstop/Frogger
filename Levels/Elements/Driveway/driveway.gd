extends Node2D

const CAR = preload("res://Levels/Elements/Driveway/car.tscn")

@onready var timer: Timer = $Timer

@export var cell : int
@export var frequency_seconds : float
@export var speed : int
@export var width_scale : float
@export var direction : int

func _ready() -> void:
	timer.wait_time = frequency_seconds
	timer.start()
	instantiate_car()
	global_position = Vector2(get_viewport_rect().size.x/2.0, get_viewport_rect().size.y - cell * Global.cell_size + Global.cell_size / 2.0)

func _on_timer_timeout() -> void:
	instantiate_car()

func instantiate_car():
	var instance = CAR.instantiate()
	instance.speed = speed
	instance.width_scale = width_scale
	instance.direction = direction
	add_child(instance)
