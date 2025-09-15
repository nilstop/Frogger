extends Node2D




@onready var map: TileMapLayer = %TileMap
@onready var timer: Timer = $Timer

@export var tilemap_atlas_coord : Vector2
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
	global_position = Vector2(Global.screen_rect.x/2.0, Global.screen_rect.y - cell * Global.cell_size + Global.cell_size / 2.0)
	set_map(30)
	

func _on_timer_timeout() -> void:
	instantiate()

func instantiate():
	var instance = entity.instantiate()
	instance.get_child(0).texture = texture
	instance.speed = speed
	instance.width_scale = width_scale
	instance.direction = direction
	add_child(instance)

func set_map(width):
	for cell in width:
		map.set_cell(map.local_to_map(global_position + Vector2(cell * Global.cell_size,0)), 0, tilemap_atlas_coord)
		map.set_cell(map.local_to_map(global_position - Vector2(cell * Global.cell_size,0)), 0, tilemap_atlas_coord)
