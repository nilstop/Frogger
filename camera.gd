extends Camera2D

@onready var frog: Area2D = %Frog
@onready var default_x_pos = Global.screen_rect.x/2

var shaketense := 0
var shake_pos := Vector2(0,0)
var shake_rot := 0


func _process(_delta: float) -> void:
	global_position = Vector2((frog.global_position.x - default_x_pos) / Global.camera_x_divide + default_x_pos, frog.global_position.y)
	global_position += shake_pos
	
	if wrap(Engine.get_frames_drawn(), 0 ,2) == 0:
		shake_pos = Vector2.RIGHT.rotated(deg_to_rad(shake_rot)) * shaketense#Vector2(randi_range(-shaketense, shaketense), randi_range(-shaketense, shaketense))
		shake_rot += randi_range(100, 140)
	shaketense = lerp(shaketense, 0, 0.2)
	
	if %Frog.state == %Frog.States.IDLE:
		position_smoothing_enabled = false
	else:
		position_smoothing_enabled = true
	
	if %Frog.state == %Frog.States.JUMP:
		zoom = lerp(zoom, Vector2(1.05, 1.05), 0.2)
	else:
		zoom = lerp(zoom, Vector2(0.95, 0.95), 0.5)
