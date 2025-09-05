extends Area2D

signal frog_death

#debugging label
@onready var label: Label = $Label

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game_start_pos := Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y - Global.cell_size/2)

@export var jump_duration : float
@export var jump_curve : Curve
#left and right movement variables
@export var wiggle_speed : int
#sin calculation for wiggle rotation
@export var wiggle_rot_FREQ : float
@export var wiggle_rot_AMP : float

enum States {WIGGLE, JUMP, IDLE}

var state : States = States.IDLE: set = set_state
var jump_start_pos : Vector2
var jump_end_pos : Vector2
var wiggle_dir : Vector2
var wiggle_rot_progress

func set_state(new_state: int):
	state = new_state
	
	if state == States.JUMP:
		animation_player.speed_scale = 1 / jump_duration
		animation_player.play("jump")
		animation_player.seek(0.0, true)
		jump_start_pos = global_position
		jump_end_pos = global_position + Vector2(0,Global.cell_size)
		if Input.is_action_pressed("left"):
			jump_end_pos += Vector2(Global.cell_size,0)
		elif Input.is_action_pressed("right"):
			jump_end_pos += Vector2(-Global.cell_size,0)
		
		var tween = create_tween()
		tween.tween_method(jump, 0.0, 1.0, jump_duration)
		await tween.finished
		set_state(States.IDLE)
	
	if state == States.WIGGLE:
		wiggle_rot_progress = 0.0
	
	if state == States.IDLE:
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			set_state(States.WIGGLE)
		
func jump(curve_time):
	global_position = jump_start_pos - jump_curve.sample(curve_time) * Vector2(jump_end_pos.x - jump_start_pos.x,Global.cell_size)

func _ready() -> void:
	global_position = game_start_pos

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Jump") and state != States.JUMP:
		#if overlaps_area():
			pass
		set_state(States.JUMP)
	
	elif Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right") and state != States.JUMP:
		if state != States.JUMP:
			set_state(States.WIGGLE)
	
	if not Input.is_action_pressed("left") and not Input.is_action_pressed("right") and state != States.JUMP:
		state = States.IDLE
	
	#walk and walk animation when state is wiggle
	if state == States.WIGGLE:
		wiggle_dir = Vector2(int(Input.is_action_pressed("right"))-int(Input.is_action_pressed("left")),0)
		global_position += wiggle_dir * wiggle_speed * delta
		wiggle_rot_progress += wiggle_rot_FREQ * delta * wiggle_dir.x
		
		rotation = deg_to_rad(sin(wiggle_rot_progress) * wiggle_rot_AMP)
	
	#reset rotation
	rotation = lerp(rotation, 0.0, 0.05)
	
	if Input.is_action_just_pressed("debug_reset"):
		show()
		global_position = game_start_pos


func _on_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("hazard"):
		death("roadkill")

func death(cause):
	emit_signal("frog_death")
	if cause == "roadkill":
		if state != States.JUMP:
			hide()
	else:
		hide()
