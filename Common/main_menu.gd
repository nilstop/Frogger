extends Control

@onready var world: Node2D = $"../.."


@onready var level_1: Button = $MarginContainer/VBoxContainer/HBoxContainer/Level1
@onready var level_2: Button = $MarginContainer/VBoxContainer/HBoxContainer/Level2
@onready var level_3: Button = $MarginContainer/VBoxContainer/HBoxContainer/Level3
@onready var level_4: Button = $MarginContainer/VBoxContainer/HBoxContainer/Level4

#HANDLES MAIN MENU BUTTON THAT STARTS A LEVEL

func disable():
	hide()
	level_1.disabled = true
	level_2.disabled = true
	level_3.disabled = true
	level_4.disabled = true

func appear():
	show()
	level_1.disabled = false
	level_2.disabled = false
	level_3.disabled = false
	level_4.disabled = false

func inst(level):
	var instance = level.instantiate()
	world.add_child(instance)

func level(level : int):
	Global.current_level = level
	inst(load(Global.PATH_TO_LEVELS + "level%d" %level + ".tscn"))
	disable()

func _on_level_1_pressed() -> void:
	level(1)

func _on_level_2_pressed() -> void:
	level(2)

func _on_level_3_pressed() -> void:
	level(3)

func _on_level_4_pressed() -> void:
	level(4)
