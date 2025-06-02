# Run.gd
extends State

func EnterState():
	print("Entered Run State")

func ExitState():
	print("Exited Run State")

func Update(delta: float) -> void:
	if not Player.is_on_floor():
		Player.changeState(States.get_node("Fall"))
	elif Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") == Vector2.ZERO:
		Player.changeState(States.get_node("Idle"))
