extends Area2D
class_name car

@onready var visible_notif: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var speed : int
var width_scale : float
var direction : int
var end_pos : Vector2

var left_corner = -Global.camera_x_divide * Global.cell_size - Global.cell_size/2.0 * width_scale
var right_corner = Global.screen_rect.x + Global.camera_x_divide * Global.cell_size + Global.cell_size/2.0 * width_scale


func _ready() -> void:
	if width_scale == 1.1:
		print(global_position.x)
	sprite_2d.scale.x = width_scale
	collision_shape.scale.x = width_scale

func _process(delta: float) -> void:
	global_position.x += direction * speed * delta * 0.5
	
	if direction == -1:
		if global_position.x < end_pos.x:
			global_position.x = right_corner
	else:
		if global_position.x > end_pos.x:
			global_position.x = left_corner
