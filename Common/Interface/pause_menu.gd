extends Control

@onready var end_screen: Control = %"End Screen"
@onready var highscore: Label = $MarginContainer/MarginContainer/VBoxContainer/Highscore
@onready var pause_sfx: AudioStreamPlayer2D = $PauseSfx
@onready var resume_sfx: AudioStreamPlayer2D = $ResumeSfx
@onready var loading_timer: Timer = get_tree().get_first_node_in_group("loadingtimer")

var paused := false

func _ready() -> void:
	loading_timer.connect("timeout", start)
	visible = false

func start():
	get_parent().get_parent().show()

func _on_pause_pressed() -> void:
	pause_sfx.play()
	visible = !visible
	if Global.get_level_highscore() != -1.0 and Global.get_level_highscore() != -2.0:
		highscore.text = "LEVEL FASTEST: " + str(Global.get_level_highscore()).pad_decimals(2) + "s"
	else:
		highscore.text = "NO FASTEST TIME"
	paused = !paused

func _on_resume_pressed() -> void:
	resume_sfx.play()
	visible = !visible
	paused = !paused

func _on_quit_to_menu_pressed() -> void:
	Global.quit_to_menu()
