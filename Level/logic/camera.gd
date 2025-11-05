extends Camera2D

@onready var frog: Area2D = %Frog
@onready var default_x_pos = Global.screen_rect.x/2
@onready var loading_timer: Timer = get_tree().get_first_node_in_group("loadingtimer")

var shaketense := 0.0
var shake_pos := Vector2(0,0)
var shake_rot := 0
var follow_frog := false

func _ready() -> void:
	make_current()
	
	loading_timer.connect("timeout", start)

func start():
	follow_frog = true

func _process(_delta: float) -> void:
	if follow_frog:#(frog.global_position.x - default_x_pos) / Global.camera_x_divide + default_x_pos
		global_position = Vector2(default_x_pos, frog.global_position.y)
		global_position.x += (frog.global_position.x - default_x_pos) / Global.camera_x_divide
		global_position += shake_pos
		
		if wrap(Engine.get_frames_drawn(), 0 ,2) == 0 and shaketense > 5:
			shake_pos = Vector2.RIGHT.rotated(deg_to_rad(shake_rot)) * shaketense
			shake_rot += randi_range(100, 140)
		shaketense = lerp(shaketense, 0.0, 0.15)
		
		if %Frog.state == %Frog.States.JUMP:
			position_smoothing_speed = 3
			zoom = lerp(zoom, Vector2(1.05, 1.05), 0.2)
		elif %Frog.state == %Frog.States.WIN:
			position_smoothing_speed = 0.5
			zoom = lerp(zoom, Vector2(0.95, 0.95), 0.06)
		else:
			position_smoothing_speed = 2.0
			zoom = lerp(zoom, Vector2(0.95, 0.95), 0.08)
		
		if  %Frog.win_animation == true:
			shaketense *= 82 * _delta
			zoom = lerp(zoom, Vector2(1.6, 1.6), 0.04)
