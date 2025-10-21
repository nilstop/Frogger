extends Control

@onready var end_screen: Control = %"End Screen"

var paused := false

func _ready() -> void:
	visible = false

func _on_pause_pressed() -> void:
	visible = !visible
	paused = !paused


func _on_resume_pressed() -> void:
	visible = !visible
	paused = !paused

func _on_quit_to_menu_pressed() -> void:
	Global.quit_to_menu()
