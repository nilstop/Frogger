extends Area2D
class_name car

@onready var visible_notif: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var sprite : Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var base_width := 128
var speed : int
var width_scale : float
var direction : int
var offset : int

func _ready() -> void:
	global_position.x = Global.screen_rect.x + Global.camera_x_divide * Global.cell_size + base_width/2.0 * width_scale
	collision_shape.scale.x = width_scale
	visible_notif.scale.x *= width_scale
	if direction == 1:
		global_position.x = -Global.camera_x_divide * Global.cell_size - base_width/2.0 * width_scale
	else:
		sprite.flip_h = true

func _process(delta: float) -> void:
	global_position.x += direction * speed * delta
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
