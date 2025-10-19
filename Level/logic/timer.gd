extends Label

@onready var frog: Area2D = get_tree().get_first_node_in_group("frog")


var await_state := true

func _ready() -> void:
	text = "0.00"
	frog.connect("start", reset)
	frog.connect("first_input", start)
	frog.connect("timer_end", stop)

func _process(delta: float) -> void:
	if await_state == false and %PauseMenu.paused == false:
		add(delta)
	else:
		if frog.state == frog.States.JUMP:
			add(delta)

func start():
	await_state = false

func reset():
	Global.time = 0.000
	text = "0.00"
	await_state = true

func add(delta):
	Global.time += delta
	text = str(Global.time).pad_decimals(2)

func stop():
	await_state = true
