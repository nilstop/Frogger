extends Label

@onready var frog: Area2D = %Frog


var await_state := true

func _ready() -> void:
	text = "0.00"
	frog.connect("start", reset)
	frog.connect("first_input", start)
	frog.connect("frog_death", stop)

func _process(delta: float) -> void:
	print(str(Global.time))
	if await_state == false:
		Global.time += delta
		set_label_text()

func start():
	await_state = false

func reset():
	Global.time = 0.000
	text = "0.00"
	await_state = true

func set_label_text():
	if Global.time > 10:
		text = str(Global.time)[0] + (str(Global.time) + "000")[1] + (str(Global.time) + "000")[2] + (str(Global.time) + "000")[3] + (str(Global.time) + "000")[4]
	else:
		text = str(Global.time)[0] + (str(Global.time) + "000")[1] + (str(Global.time) + "000")[2] + (str(Global.time) + "000")[3]
	
func stop():
	await_state = true
