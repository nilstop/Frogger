extends Camera2D

@onready var frog: Area2D = %Frog
@onready var default_x_pos = Global.screen_rect.x/2

var shaketense := 0.0
var shake_pos := Vector2(0,0)
var shake_rot := 0


func _process(_delta: float) -> void:
	global_position = Vector2((frog.global_position.x - default_x_pos) / Global.camera_x_divide + default_x_pos, frog.global_position.y)
	global_position += shake_pos
	
	if wrap(Engine.get_frames_drawn(), 0 ,2) == 0 and shaketense > 5:
		shake_pos = Vector2.RIGHT.rotated(deg_to_rad(shake_rot)) * shaketense#Vector2(randi_range(-shaketense, shaketense), randi_range(-shaketense, shaketense))
		
		shake_rot += randi_range(100, 140)
	shaketense = lerp(shaketense, 0.0, 0.15)
	
	if %Frog.state == %Frog.States.JUMP:
		position_smoothing_speed = 1.5
		zoom = lerp(zoom, Vector2(1.05, 1.05), 0.2)
	else:
		position_smoothing_speed = 2.0
		zoom = lerp(zoom, Vector2(0.95, 0.95), 0.08)
	
	if  %Frog.win_animation == true:
		shaketense *= 79.8 * _delta
		print(shaketense)
		zoom = lerp(zoom, Vector2(1.6, 1.6), 0.04)
