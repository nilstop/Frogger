extends Area2D
class_name car

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var base_width = sprite_2d.texture.get_width()

var speed : int = 1500
var width_scale : float = 1
var direction : int = -1
var offset : int

func _ready() -> void:
	global_position.x = get_viewport_rect().size.x / 2
	sprite_2d.scale.x = width_scale
	if direction == 1:
		position.x = -get_viewport_rect().size.x - base_width / 2 * width_scale
	elif direction == -1:
		position.x = get_viewport_rect().size.x + base_width / 2 * width_scale

func _process(delta: float) -> void:
	position.x += direction * speed * delta
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
