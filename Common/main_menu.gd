extends Control

@onready var world: Node2D = $"../.."
@onready var camera_2d: Camera2D = $"../../Camera2D"
@onready var layers: Node2D = $"../../Layers"
@onready var load_sfx: AudioStreamPlayer = $"../../LoadSfx"
@onready var margin_container: MarginContainer = $MarginContainer
@onready var loading_timer: Timer = get_tree().get_first_node_in_group("loadingtimer")
@onready var leaf_particles: GPUParticles2D = %GPUParticles2D





#HANDLES MAIN MENU BUTTON THAT STARTS A LEVEL

const LABEL_PATH := "MarginContainer/VBoxContainer/All Buttons/%d Buttons/Button%d/Highscore"
const BUTTON_PATH := "MarginContainer/VBoxContainer/All Buttons/%d Buttons/Button%d/Level%d"

func _ready() -> void:
	labels()
	loading_timer.connect("timeout", done_loading)
	camera_2d.make_current()

func disable():
	hide()
	#margin_container.hide()
	#leaf_particles.hide()
	await get_tree().process_frame
	layers.hide()

func appear():
	show()
	#leaf_particles.show()
	#margin_container.show()
	layers.show()
	camera_2d.make_current()
	labels()

func get_button(button):
	return get_node(BUTTON_PATH %[button, button])

func get_label(label):
	if label < 5:
		return get_node(LABEL_PATH %[1, label])
	else:
		return get_node(LABEL_PATH %[2, label])
	return# get_node(LABEL_PATH %label)

	#return load(BUTTON_PATH %[level, level])

func labels():
	for i in 8:
		if Global.highscores[i] != -1.00:
			get_label(i+1).text = str(Global.highscores[i]).pad_decimals(2) + "s"
		else:
			get_label(i+1).text = ""

func inst(level):
	var instance
	
	if level != null:
		instance = level.instantiate()
	else:
		instance = load(Global.PATH_TO_DEFAULT_LEVEL).instantiate()
	world.add_child(instance)

func level(level : int):
	load_sfx.play()
	Global.current_level = level
	inst(load(Global.PATH_TO_LEVELS + "level%d" %level + ".tscn"))
	Global.load_level()
	loading_timer.start()
	disable()

func _on_level_1_pressed() -> void:
	level(1)

func _on_level_2_pressed() -> void:
	level(2)

func _on_level_3_pressed() -> void:
	level(3)

func _on_level_4_pressed() -> void:
	level(4)

func _on_level_5_pressed() -> void:
	level(5)

func _on_level_6_pressed() -> void:
	level(6)

func _on_level_7_pressed() -> void:
	level(7)

func _on_level_8_pressed() -> void:
	level(8)

func done_loading() -> void:
	hide()
