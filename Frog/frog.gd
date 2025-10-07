extends Area2D

signal frog_death

#debugging label
@onready var label: Label = $Label

#hitboxes
@onready var log_area: Area2D = $LogArea
@onready var river_area: Area2D = $RiverArea
@onready var goal_area: Area2D = $GoalArea


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game_start_pos := Vector2(get_viewport_rect().size.x/2.0, get_viewport_rect().size.y - Global.cell_size/2.0)

@export var death_fx : PackedScene
@export var land_particles : PackedScene
@export var jump_duration : float
@export var jump_curve : Curve

enum States {JUMP, IDLE, DEAD, WIN}

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
		print("jumpfinished")
		if check_collision():
			print("jump fnsh coll action")
			collision_action(check_collision())
		else:
			set_state(States.IDLE)
	
	if state == States.IDLE:
		if !check_collision():
			inst(land_particles, "land_particles")
			%Camera2D.shaketense += 400
			%Camera2D.zoom = Vector2(0.9, 0.9)
	
	if state == States.WIN:
		print("win")

func jump(curve_time):
	global_position = jump_start_pos - jump_curve.sample(curve_time) * Vector2(jump_end_pos - jump_start_pos.x,Global.cell_size)

func _ready() -> void:
	global_position = game_start_pos

func _physics_process(delta: float) -> void:
	print(state)
	if state != States.DEAD and state != States.WIN:
		#jump when jump buttons pressed
		if Input.is_action_pressed("Jump") and state != States.JUMP:
			set_state(States.JUMP)
	
	#label.text = str(state)
	if state != States.DEAD and state != States.WIN:
	#check collision when state is idle
		if state == States.IDLE:
			global_position.x += log_velocity * delta
			if check_collision():
				collision_action(check_collision())
	
	if Input.is_action_just_pressed("debug_reset"):
		global_position = game_start_pos
		show()
		set_state(States.IDLE)

#run collision_action() if you're colliding with the masked layer
func check_collision():
	print("collission checked")
	if has_overlapping_areas():
		return "roadkill"
	if goal_area.has_overlapping_areas():
		return "win"
	if river_area.has_overlapping_areas():
		if log_area.has_overlapping_areas():
			var log = log_area.get_overlapping_areas().get(0)
			log_velocity = log.speed * log.direction
		else:
			print("drown")
			return "drowned"
	else:
		log_velocity = 0
		return
	


func collision_action(action: String):
	print("death")
	emit_signal("frog_death")
	if action == "roadkill":
		hide()
		set_state(States.DEAD)
	elif action == "drowned":
		hide()
		inst(death_fx, "death_fx")
		set_state(States.DEAD)
	elif action == "win":
		print("win")
		set_state(States.WIN)
	else:
		set_state(States.IDLE)


func inst(scene : PackedScene, type : String):
	var instance = scene.instantiate()
	if type == "land_particles":
		instance.get_child(0).emitting = true
	instance.global_position = global_position
	add_sibling(instance)
	get_parent().move_child(instance, get_index())
