extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var jump_duration : float
@export var jump_curve : Curve

enum States {JUMP, IDLE}

var state : States = States.IDLE: set = set_state
var jump_start_pos
var jump_end_pos

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump") and state != States.JUMP:
		set_state(States.JUMP)
	
	
	if Input.is_action_just_pressed("debug_reset"):
		global_position = Vector2(708.0,731.0)

func jump(curve_time):
	global_position.y = jump_start_pos - jump_curve.sample(curve_time) * Global.cell_size

func set_state(new_state: int):
		state = new_state
		if state == States.JUMP:
			animation_player.speed_scale = 1 / jump_duration
			animation_player.play("jump")
			animation_player.seek(0.0, true)
			jump_start_pos = global_position.y
			jump_end_pos = global_position.y + Global.cell_size
			var tween = create_tween()
			tween.tween_method(jump, 0.0, 1.0, jump_duration)
			await tween.finished
			set_state(States.IDLE)
