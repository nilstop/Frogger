extends Node2D


@onready var timer: Timer = $Timer
@onready var tile_map_script: Node2D = $TileMapScript


@export var entity : PackedScene
@export var texture : Texture2D
## How far away from the start the element is. Cell is multiplied by 128 (grid cell size) to get desired the position.
@export var cell : int
@export var frequency_seconds : float
## The speed of which the entities moves through the lane.
@export var speed : int
## The direction the entities will head. -1 will make them head left and 1 right.
@export var direction : int

@onready var width_scale : float = texture.get_size().x / 16.0

func _ready() -> void:
	
	timer.wait_time = frequency_seconds
	timer.start()
	#set position using the exported cell variable, which is how far in the level the element is
	
	

func _on_timer_timeout() -> void:
	instantiate()

func instantiate():
	var instance = entity.instantiate()
	instance.get_child(0).texture = texture
	instance.speed = speed
	instance.width_scale = width_scale
	instance.direction = direction
	add_child(instance)
