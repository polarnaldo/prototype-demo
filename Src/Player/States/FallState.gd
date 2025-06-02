# Fall.gd
extends State

func EnterState():
	print("Entered Fall State")

func ExitState():
	print("Exited Fall State")

func Update(delta: float) -> void:
	if Player.is_on_floor() and Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") == Vector2.ZERO:
		Player.changeState(States.get_node("Idle"))
	elif Player.is_on_floor() and Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") != Vector2.ZERO:
		Player.changeState(States.get_node("Run"))
		
