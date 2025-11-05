extends Control

@onready var end_screen: Control = %"End Screen"
@onready var highscore: Label = $MarginContainer/MarginContainer/VBoxContainer/Highscore

var paused := false

func _ready() -> void:
	visible = false

func _on_pause_pressed() -> void:
	visible = !visible
	if Global.get_level_highscore() != -1.0:
		highscore.text = "LEVEL FASTEST: " + str(Global.get_level_highscore()).pad_decimals(2) + "s"
	else:
		highscore.text = "NO FASTEST TIME"
	paused = !paused



func _on_resume_pressed() -> void:
	visible = !visible
	paused = !paused

func _on_quit_to_menu_pressed() -> void:
	Global.quit_to_menu()
