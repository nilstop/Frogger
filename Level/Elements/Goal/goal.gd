extends Node2D

@export var cell : int

@onready var camera_2d: Camera2D = %Camera2D

func _ready() -> void:
	camera_2d.position = position - Vector2(0, Global.cell_size * 2)
