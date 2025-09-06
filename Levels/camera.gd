extends Camera2D

@onready var frog: Area2D = %Frog
@onready var label: Label = $Label
@onready var default_x_pos = get_viewport_rect().size.x/2

@export var x_divide : int 




func _process(_delta: float) -> void:
	global_position = Vector2((frog.global_position.x - default_x_pos) / x_divide + default_x_pos, frog.global_position.y)
	label.text = str(global_position - frog.global_position)
