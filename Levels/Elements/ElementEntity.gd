extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var speed : int
var width_scale : float
var direction : int
var end_pos : Vector2

var left_corner : float
var right_corner : float


func _ready() -> void:
	left_corner = -Global.camera_x_divide * Global.cell_size - Global.cell_size/2.0 * width_scale
	right_corner = Global.screen_rect.x + Global.camera_x_divide * Global.cell_size + Global.cell_size/2.0 * width_scale
	
	sprite_2d.scale.x = width_scale
	collision_shape.scale.x = width_scale
	if width_scale == 1.1:
		print(global_position.x)

func _process(delta: float) -> void:
	global_position.x += direction * speed * delta
	
	if direction == -1:
		if global_position.x < end_pos.x:
			global_position.x = right_corner
	else:
		if global_position.x > end_pos.x:
			global_position.x = left_corner
