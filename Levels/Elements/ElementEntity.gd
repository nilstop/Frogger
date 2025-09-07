extends Area2D
class_name car

@onready var visible_notif: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var base_width = sprite_2d.texture.get_width()

var speed : int = 1500
var width_scale : float = 1
var direction : int = -1
var offset : int

func _ready() -> void:
	#global_position.x = Global.screen_rect.x + Global.camera_x_divide * Global.cell_size + base_width/2.0 * width_scale
	sprite_2d.scale.x = width_scale
	collision_shape.scale.x = width_scale
	visible_notif.scale.x *= width_scale
	#if direction == 1:
		#global_position.x = -Global.camera_x_divide * Global.cell_size - base_width/2.0 * width_scale

func _process(delta: float) -> void:
	global_position.x += direction * speed * delta
	if direction == -1:
		if global_position.x < -Global.camera_x_divide * Global.cell_size - base_width/2.0 * width_scale:
			global_position.x = Global.screen_rect.x + Global.camera_x_divide * Global.cell_size + base_width/2.0 * width_scale
	else:
		if global_position.x > Global.screen_rect.x + Global.camera_x_divide * Global.cell_size + base_width/2.0 * width_scale:
			global_position.x = -Global.camera_x_divide * Global.cell_size - base_width/2.0 * width_scale
