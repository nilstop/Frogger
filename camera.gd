extends Camera2D

@onready var frog: Area2D = %Frog
@onready var label: Label = $Label
@onready var default_x_pos = Global.screen_rect.x/2

#@export var shake_interval_frames

var shaketense := 0
var shake_pos := Vector2(0,0)
var run := 0


func _process(_delta: float) -> void:
	#run += 1
	#if 
	global_position = Vector2((frog.global_position.x - default_x_pos) / Global.camera_x_divide + default_x_pos, frog.global_position.y)
	global_position += shake_pos
	label.text = str(global_position - frog.global_position)
	
	if wrap(Engine.get_frames_drawn(), 0 ,1) == 0:
		shake_pos = Vector2.RIGHT.rotated(deg_to_rad(randi_range(0,360))) * shaketense#Vector2(randi_range(-shaketense, shaketense), randi_range(-shaketense, shaketense))
	shaketense = lerp(shaketense, 0, 0.25)
	
	if %Frog.state == %Frog.States.JUMP:
		position_smoothing_speed = 1.2
		zoom = lerp(zoom, Vector2(1.05, 1.05), 0.2)
	else:
		position_smoothing_speed = 2.0
		zoom = lerp(zoom, Vector2(1.0, 1.0), 0.5)
