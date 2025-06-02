# Jump.gd
extends State

func EnterState():
	print("Entered Jump State")
	Player.velocity.y = Player.JUMP_SPEED
	Player.coyote_timer = 0

func ExitState():
	print("Exited Jump State")

func Update(delta: float) -> void:
	if Player.velocity.y < 0:
		Player.changeState(States.get_node("Fall"))
