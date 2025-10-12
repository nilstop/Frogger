extends Control


@onready var input_message: Label = $VBoxContainer/InputMessage
@onready var case: Label = $VBoxContainer/Case
@onready var timer: Timer = $Timer
@onready var disappeartimer: Timer = $DisappearTimer

var frog
var death_screen := false

func _ready() -> void:
	frog = get_tree().get_first_node_in_group("frog")
	frog.connect("frog_death", appear)
	case.hide()
	input_message.hide()

func _process(delta: float) -> void:
	if death_screen:
		if Input.is_action_just_pressed("debug_reset"):
			disappear()

func appear():
	timer.wait_time = 0.3
	timer.start()
	death_screen = true
	case.show()
	input_message.show()

func disappear():
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
