extends Area2D

signal frog_death
signal timer_end
signal end
signal first_input
signal start

#debugging label
@onready var label: Label = $Label

#hitboxes
@onready var log_area: Area2D = $LogArea
@onready var river_area: Area2D = $RiverArea
@onready var goal_area: Area2D = $GoalArea
@onready var train_area: Area2D = $TrainArea
#AudioStreamPlayers
@onready var jump_sfx: AudioStreamPlayer2D = $JumpSfx
@onready var land_sfx: AudioStreamPlayer2D = $LandSfx
@onready var win_sfx: AudioStreamPlayer2D = $WinSfx
@onready var drown_sfx: AudioStreamPlayer2D = $DrownSfx
@onready var hit_sfx: AudioStreamPlayer2D = $HitSfx

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var game_start_pos := Vector2(Global.screen_rect.x/2, Global.screen_rect.y - Global.cell_size/2.0)
@onready var pause_menu: Control = %PauseMenu

#animation related
@export var death_fx : PackedScene
@export var land_particles : PackedScene
@export var jump_duration : float
@export var jump_curve : Curve
@export var win_anim_duration : float = jump_duration * 2

enum States {JUMP, IDLE, DEAD, WIN}

var state : States = States.IDLE: set = set_state 
var jump_start_pos : Vector2
var jump_end_pos : Vector2
var log_velocity : int
var win_animation := false

func set_state(new_state: int):
	state = new_state
	
	if state == States.JUMP:
		emit_signal("first_input")
		jump_start_pos = global_position
		jump_end_pos = global_position + Vector2(0, Global.cell_size)
		jump_sfx.play()
		#diagonal jumping
		if Input.is_action_pressed("left"):
			jump_end_pos += Vector2(Global.cell_size,0)
			animation_player.play("jump_left")
		elif Input.is_action_pressed("right"):
			jump_end_pos -= Vector2(Global.cell_size,0)
			animation_player.play("jump_right")
		else:
			animation_player.play("jump")
			rotation = 0
		#animation
		animation_player.speed_scale = 1.0 / jump_duration
		animation_player.seek(0.0, true)
		var tween = create_tween()
		tween.tween_method(jump, 0.0, 1.0, jump_duration)
		await tween.finished
		if check_collision():
			collision_action(check_collision())
		else:
			set_state(States.IDLE)
	
	if state == States.IDLE:
		if !check_collision():
			land_sfx.play()
			land_fx()
	
	if state == States.WIN:
		win_animation = true
		win_sfx.play()
		inst(land_particles, "land_particles")
		%Camera2D.shaketense = 1
		jump_start_pos = global_position
		jump_end_pos = global_position + Vector2(0, Global.cell_size * 3)
		animation_player.play("win")
		animation_player.speed_scale = 0.25 / jump_duration * 2
		animation_player.seek(0.0, true)
		var tween = create_tween()
		tween.tween_method(jump, 0.0, 1.0, jump_duration * 2)
		await tween.finished
		global_position.x = game_start_pos.x
		emit_signal("end")
		win_animation = false
		%Camera2D.zoom = Vector2(0.65, 0.65)
		hide()
		inst(death_fx, "death_fx")
	
func jump(curve_time):
	global_position = jump_start_pos - jump_curve.sample(curve_time) * Vector2(jump_end_pos.x - jump_start_pos.x,jump_end_pos.y - jump_start_pos.y)

func _ready() -> void:
	emit_signal("start")
	global_position = game_start_pos

func _physics_process(delta: float) -> void:
	if state != States.DEAD and state != States.WIN and %PauseMenu.paused == false:
		
			
		#jump when jump buttons pressed
		if Input.is_action_pressed("Jump") and state != States.JUMP:
			set_state(States.JUMP)
	
	#label.text = str(state)
	if state != States.DEAD and state != States.WIN:
	#check collision when state is idle
		if state == States.IDLE:
			if pause_menu.paused == false:
				global_position.x += log_velocity * delta
			if check_collision():
				collision_action(check_collision())
	if state == States.JUMP or state == States.IDLE:
		if train_area.has_overlapping_areas():
			collision_action(check_collision())
	
	if Input.is_action_just_pressed("debug_reset"):
		if state != States.JUMP and win_animation == false:
			emit_signal("start")
			rotation = deg_to_rad(0.0)
			global_position = game_start_pos
			show()
			set_state(States.IDLE)

#run collision_action() if you're colliding with the masked layer
func check_collision():
	if global_position.x < Global.level_width * Global.cell_size and global_position.x < -Global.level_width * Global.cell_size:
		return "out of bounds"	
	if train_area.has_overlapping_areas():
		return "railkill"
	elif has_overlapping_areas():
		return "roadkill"
	elif goal_area.has_overlapping_areas():
		return "win"
	if river_area.has_overlapping_areas():
		if log_area.has_overlapping_areas():
			var LOG = log_area.get_overlapping_areas().get(0)
			log_velocity = LOG.speed * LOG.direction
		else:
			return "drowned"
	else:
		log_velocity = 0
		return

func basic_death():
	hide()
	set_state(States.DEAD)
	emit_signal("frog_death")

func collision_action(action: String):
	emit_signal("timer_end")
	if action == "roadkill":
		hit_sfx.play()
		basic_death()
	elif action == "railkill":
		hit_sfx.play()
		basic_death()
	elif action == "drowned":
		drown_sfx.play()
		inst(death_fx, "death_fx")
		basic_death()
	elif action == "out of bounds":
		basic_death()
	elif action == "win":
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

func land_fx():
	inst(land_particles, "land_particles")
	%Camera2D.shaketense += 300.0
	%Camera2D.zoom = Vector2(0.9, 0.9)
