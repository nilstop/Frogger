extends Control

@onready var world: Node2D = $"../.."
@onready var camera_2d: Camera2D = $"../../Camera2D"
@onready var layers: Node2D = $"../../Layers"
@onready var load_sfx: AudioStreamPlayer2D = $"../../LoadSfx"
@onready var margin_container: MarginContainer = $MarginContainer
@onready var loading_timer: Timer = get_tree().get_first_node_in_group("loadingtimer")




#HANDLES MAIN MENU BUTTON THAT STARTS A LEVEL

const LABEL_PATH := "MarginContainer/VBoxContainer/HBoxContainer/Button%d/Highscore"
const BUTTON_PATH := "MarginContainer/VBoxContainer/HBoxContainer/Button%d/Level%d"

func _ready() -> void:
	loading_timer.connect("timeout", done_loading)
	camera_2d.make_current()

func disable():
	margin_container.hide()
	get_button(1).disabled = true
	get_button(2).disabled = true
	get_button(3).disabled = true
	get_button(4).disabled = true
	await get_tree().process_frame
	layers.hide()

func appear():
	show()
	margin_container.show()
	get_button(1).disabled = false
	get_button(2).disabled = false
	get_button(3).disabled = false
	get_button(4).disabled = false
	layers.show()
	camera_2d.make_current()
	labels()

func get_button(button):
	return get_node(BUTTON_PATH %[button, button])

func get_label(label):
	return get_node(LABEL_PATH %label)

	#return load(BUTTON_PATH %[level, level])

func labels():
	for i in 4:
		if Global.highscores[i] != -1.00:
			get_label(i+1).text = str(Global.highscores[i]).pad_decimals(2) + "s"
		else:
			get_label(i+1).text = "--"

func inst(level):
	var instance = level.instantiate()
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


func done_loading() -> void:
	hide()
