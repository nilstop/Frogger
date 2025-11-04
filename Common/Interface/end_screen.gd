extends Control



@onready var input_message: Label = $MarginContainer/VBoxContainer/InputMessage
@onready var case: Label = $MarginContainer/VBoxContainer/Case
@onready var timer: Timer = $Timer
@onready var timer_label: Label = $"../VBoxContainer/Timer"
@onready var disappeartimer: Timer = $DisappearTimer
@onready var h_separator: HSeparator = $MarginContainer/VBoxContainer/HSeparator
@onready var pause_menu: Control = %PauseMenu
@onready var buttons: HBoxContainer = $MarginContainer/Buttons
@onready var next_level: VBoxContainer = $"MarginContainer/Buttons/Next Level"
@onready var highscore_beaten_label: Label = $"../VBoxContainer/New Highscore"




var frog
var death_screen := false
var disappearing := false
var highscore_beaten := false

func _ready() -> void:
	frog = get_tree().get_first_node_in_group("frog")
	frog.connect("frog_death", appear)
	frog.connect("end", appear)
	frog.connect("win", check_highscore)
	buttons.hide()
	case.hide()
	input_message.hide()

func debug():
	print("frog death")

func _process(_delta: float) -> void:
	if death_screen:
		if Input.is_action_just_pressed("debug_reset") and disappearing == false:
			disappearing = true
			disappear()
		if pause_menu.paused == true:
			hide()
		else:
			show()

func check_highscore():
	print("check")
	if Global.time < Global.highscores[Global.current_level - 1] or Global.highscores[Global.current_level - 1.0] == -1.0:
		Global.highscores[Global.current_level - 1.0] = Global.time
		print("highscore beaten")
		highscore_beaten = true
		timer_label.modulate = Color.YELLOW
		highscore_beaten_label.show()
	else:
		print("highscore not beaten")
		highscore_beaten = false
		highscore_beaten_label.hide()
		timer_label.modulate = Color.WHITE

func appear():
	print("appear")
	disappearing = false
	#If end screen is win screen
	if frog.state == frog.States.WIN:
		print("win")

		case.text = "LEVEL CLEARED"
		input_message.text = "PRESS ENTER TO REPLAY"
		buttons.show()
	#if end screen is death screen
	else:
		print("failed")
		case.text = "FAILED"
		input_message.text = "PRESS ENTER TO RETRY"
		buttons.hide()
	h_separator.add_theme_constant_override("separation", 110)
	timer.wait_time = 0.3
	timer.start()
	death_screen = true
	case.show()
	input_message.show()

func disappear():
	h_separator.add_theme_constant_override("separation", 174)
	case.hide()
	buttons.hide()
	input_message.hide()
	timer.wait_time = 0.05
	timer.start()
	disappeartimer.start()
	highscore_beaten_label.hide()

func _on_timer_timeout() -> void:
	if death_screen == true:
		input_message.visible = !input_message.visible
		if highscore_beaten == true:
			print("flash")
			highscore_beaten_label.visible = !highscore_beaten_label.visible


func _on_disappear_timer_timeout() -> void:
	death_screen = false
	input_message.hide()


func _on_quit_to_menu_pressed() -> void:
	Global.quit_to_menu()

func _on_next_level_button_pressed() -> void:
	get_tree().get_first_node_in_group("loadsfx").play()
	print(Global.PATH_TO_LEVELS + "level%d" %(Global.current_level + 1) + ".tscn")
	Global.switch(Global.PATH_TO_LEVELS + "level%d" %(Global.current_level + 1) + ".tscn")
