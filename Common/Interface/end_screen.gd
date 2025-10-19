extends Control



@onready var input_message: Label = $VBoxContainer/InputMessage
@onready var case: Label = $VBoxContainer/Case
@onready var timer: Timer = $Timer
@onready var disappeartimer: Timer = $DisappearTimer
@onready var h_separator: HSeparator = $VBoxContainer/HSeparator
@onready var pause_menu: Control = %PauseMenu


var frog
var death_screen := false
var disappearing := false

func _ready() -> void:
	frog = get_tree().get_first_node_in_group("frog")
	frog.connect("frog_death", appear)
	frog.connect("end", appear)
	case.hide()
	input_message.hide()

func _process(delta: float) -> void:
	if death_screen:
		if Input.is_action_just_pressed("debug_reset") and disappearing == false:
			disappearing = true
			disappear()
		if pause_menu.paused == true:
			hide()
		else:
			show()

func appear():
	disappearing = false
	print(str(frog.state))
	if frog.state == frog.States.WIN:
		case.text = "LEVEL CLEARED"
		input_message.text = "PRESS ENTER TO REPLAY"
	else:
		case.text = "FAILED"
		input_message.text = "PRESS ENTER TO RETRY"
	h_separator.add_theme_constant_override("separation", 110)
	timer.wait_time = 0.3
	timer.start()
	death_screen = true
	case.show()
	input_message.show()

func disappear():
	h_separator.add_theme_constant_override("separation", 174)
	case.hide()
	input_message.hide()
	timer.wait_time = 0.05
	timer.start()
	disappeartimer.start()

func _on_timer_timeout() -> void:
	if death_screen == true:
		input_message.visible = !input_message.visible


func _on_disappear_timer_timeout() -> void:
	death_screen = false
	input_message.hide()
