extends Control

@onready var world: Node2D = $"../.."
@onready var camera_2d: Camera2D = $"../../Camera2D"
@onready var layers: Node2D = $"../../Layers"
@onready var load_sfx: AudioStreamPlayer = $"../../LoadSfx"
@onready var bonus_level_sfx: AudioStreamPlayer = $"../../BonusLevelSfx"
@onready var margin_container: MarginContainer = $MarginContainer
@onready var loading_timer: Timer = get_tree().get_first_node_in_group("loadingtimer")
@onready var leaf_particles: GPUParticles2D = %GPUParticles2D
@onready var message: Label = $MarginContainer/VBoxContainer/Title2

#bonus level and animations
@onready var bonus_highscore: Label = $"MarginContainer/VBoxContainer/All Buttons/MarginContainer/Bonus Level Button/BonusHighscore"
@onready var bonus_separator: Control = $"MarginContainer/VBoxContainer/All Buttons/HSeparator2"
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var all_buttons: VBoxContainer = $"MarginContainer/VBoxContainer/All Buttons"
@onready var button_separator: Control = $"MarginContainer/VBoxContainer/All Buttons/HSeparator"
@onready var title_separator: Control = $MarginContainer/VBoxContainer/Separator2
@onready var message_separator: Control = $MarginContainer/VBoxContainer/Separator3
@onready var bonus_button: MarginContainer = $"MarginContainer/VBoxContainer/All Buttons/MarginContainer"


var test := 1


#HANDLES MAIN MENU BUTTON THAT STARTS A LEVEL

const LABEL_PATH := "MarginContainer/VBoxContainer/All Buttons/%d Buttons/Button%d/Highscore"
const BUTTON_PATH := "MarginContainer/VBoxContainer/All Buttons/%d Buttons/Button%d/Level%d"


func _ready() -> void:
	labels()
	bonus_level()
	loading_timer.connect("timeout", done_loading)
	camera_2d.make_current()

func disable():
	hide()
	#margin_container.hide()
	leaf_particles.hide()
	await get_tree().process_frame
	layers.hide()

func appear():
	show()
	bonus_level()
	leaf_particles.show()
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

func labels():
	for i in 8:
		if Global.highscores[i] >= 0.00:
			get_label(i+1).text = str(Global.highscores[i]).pad_decimals(2) + "s"
		else:
			get_label(i+1).text = ""
	if Global.highscores[8] != -2.00:
		bonus_highscore.show()
		bonus_highscore.text = str(Global.highscores[8]).pad_decimals(2) + "s"
	else:
		bonus_highscore.hide()
	
func inst(new_level):
	var instance
	
	if level != null:
		instance = new_level.instantiate()
	else:
		instance = load(Global.PATH_TO_DEFAULT_LEVEL).instantiate()
	world.add_child(instance)

func level(new_level : int):
	load_sfx.play()
	Global.current_level = new_level
	inst(load(Global.PATH_TO_LEVELS + "level%d" %new_level + ".tscn"))
	Global.load_level()
	loading_timer.start()
	disable()

func bonus_level():
	if !Global.highscores.has(-1.00) or test == 1:
		bonus_button.show()
		message.modulate = Color.YELLOW
		message.text = "THANK YOU FOR PLAYING!"
		
		if Global.highscores.has(-2.00):
			bonus_animation()
		else:
			bonus_separator.custom_minimum_size.y = 16.0
			title_separator.custom_minimum_size.y = 32.0
			button_separator.custom_minimum_size.y = 16.0
			message_separator.custom_minimum_size.y = 32.0
	else:
		bonus_button.hide()
	
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

func _on_button_pressed() -> void:
	level(9)

func done_loading() -> void:
	hide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_reset"):
			bonus_animation()

func bonus_animation():
	bonus_button.show()
	message.modulate = Color.YELLOW
	message.text = "THANK YOU FOR PLAYING!"
	bonus_level_sfx.play()
	bonus_separator.custom_minimum_size.y = 400.0
	title_separator.custom_minimum_size.y = 64.0
	button_separator.custom_minimum_size.y = 32.0
	message_separator.custom_minimum_size.y = 64.0
	var tween = create_tween()
	tween.tween_property(bonus_separator, "custom_minimum_size:y", 16.0, 1.4).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(title_separator, "custom_minimum_size:y", 32.0, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_delay(0.5)
	tween.parallel().tween_property(button_separator, "custom_minimum_size:y", 16.0, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_delay(0.5)
	tween.parallel().tween_property(message_separator, "custom_minimum_size:y", 32.0, 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_delay(0.5)
