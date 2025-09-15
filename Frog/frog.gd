extends Area2D

signal frog_death

#debugging label
@onready var label: Label = $Label

#hitboxes
@onready var log_area: Area2D = $LogArea
@onready var river_area: Area2D = $RiverArea

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game_start_pos := Vector2(get_viewport_rect().size.x/2.0, get_viewport_rect().size.y - Global.cell_size/2.0)

@export var land_particles : PackedScene
@export var jump_duration : float
@export var jump_curve : Curve

enum States {JUMP, IDLE, DEAD}

var state : States = States.IDLE: set = set_state
var jump_start_pos : Vector2
var jump_end_pos : float
var log_velocity : int

func set_state(new_state: int):
	state = new_state
	
	if state == States.JUMP:
		
		jump_start_pos = global_position
		jump_end_pos = global_position.x
		#diagonal jumping
		if Input.is_action_pressed("left"):
			jump_end_pos += Global.cell_size
			animation_player.play("jump_left")
		elif Input.is_action_pressed("right"):
			jump_end_pos -= Global.cell_size
			animation_player.play("jump_right")
		else:
			animation_player.play("jump")
			rotation = 0
		animation_player.speed_scale = 1.0 / jump_duration
		animation_player.seek(0.0, true)
		var tween = create_tween()
		tween.tween_method(jump, 0.0, 1.0, jump_duration)
		await tween.finished
		set_state(States.IDLE)
	
	if state == States.IDLE:
		if !check_collision():
			inst(land_particles)
			%Camera2D.shaketense += 400
			%Camera2D.zoom = Vector2(0.95, 0.95)

func jump(curve_time):
	global_position = jump_start_pos - jump_curve.sample(curve_time) * Vector2(jump_end_pos - jump_start_pos.x,Global.cell_size)

func _ready() -> void:
	global_position = game_start_pos

func _physics_process(delta: float) -> void:
	if state != States.DEAD:
		#jump when jump buttons pressed
		if Input.is_action_pressed("Jump") and state != States.JUMP:
			set_state(States.JUMP)
		
		#check collision when state is idle
		if state == States.IDLE:
			global_position.x += log_velocity * delta
			check_collision()
	
	if Input.is_action_just_pressed("debug_reset"):
		global_position = game_start_pos
		show()
		set_state(States.IDLE)

#run death() if you're colliding with the masked layer
func check_collision():
	if has_overlapping_areas():
		death("roadkill")
		return "roadkill"
	if river_area.has_overlapping_areas():
		if log_area.has_overlapping_areas():
			var log = log_area.get_overlapping_areas().get(0)
			log_velocity = log.speed * log.direction
		else:
			death("drowned")
			return "drowned"
	else:
		log_velocity = 0

func death(cause: String):
	
	emit_signal("frog_death")
	if cause == "roadkill":
		if state != States.JUMP:
			hide()
	else:
		hide()
	set_state(States.DEAD)

func inst(scene):
	var instance = scene.instantiate()
	instance.get_child(0).emitting = true
	instance.global_position = global_position
	add_sibling(instance)
	get_parent().move_child(instance, get_index())
