extends Area2D

@onready var sprite : Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var pause_menu = get_tree().get_first_node_in_group("pausemenu")
@onready var gpu_particles_2d: GPUParticles2D


@export var offset : int

var base_width := 128
var speed : int
var width_scale : float
var direction : int





var left_corner : float
var right_corner : float

func _ready() -> void:
	if get_children().size() == 3: gpu_particles_2d = $GPUParticles2D
	left_corner = -Global.camera_x_divide * Global.cell_size - Global.cell_size/2.0 * width_scale
	right_corner = Global.screen_rect.x + Global.camera_x_divide * Global.cell_size + Global.cell_size/2.0 * width_scale
	global_position.x = Global.screen_rect.x + Global.camera_x_divide * Global.cell_size + base_width/2.0 * width_scale
	global_position.y -= offset
	collision_shape.scale.x = width_scale
	if direction == 1:
		global_position.x = -Global.camera_x_divide * Global.cell_size - base_width/2.0 * width_scale
	else:
		sprite.flip_h = true
		if get_children().size() == 3:
			gpu_particles_2d.position.x *= -1
			gpu_particles_2d.process_material.direction.x *= -1
		
		collision_shape.position.x *= -1

func _process(delta: float) -> void:
	if pause_menu.paused == false:
		global_position.x += direction * speed * delta
	if direction == -1:
		if global_position.x < left_corner:
			queue_free()
	else:
		if global_position.x > right_corner + Global.screen_rect.x/2:
			queue_free()
