# Idle.gd
extends State

func EnterState():
	print("Entered Idle State")

func ExitState():
	print("Exited Idle State")

func Update(delta: float) -> void:
	if Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") != Vector2.ZERO:
		Player.changeState(States.get_node("Run"))
