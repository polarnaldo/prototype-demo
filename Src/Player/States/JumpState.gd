extends State

func EnterState():
	print("Entered Jump State")
	Player.animation.play("Jump")
	Jump()

func ExitState():
	print("Exited Jump State")

func Update(_delta: float) -> void:
	if ActionType.is_falling(Player):
		transitioned.emit("Fall")

func PhysicsUpdate(delta: float) -> void:
	var input_dir = Player.GetInputMovement()
	var direction = Player.GetDirection()
	Player.HandleHorizontalMovement(direction, delta)
	Player.HandleGravity(delta)
	Player.SetAnimation(input_dir)
	Player.move_and_slide()

func Jump():
	Player.velocity.y = Player.JUMP_SPEED
