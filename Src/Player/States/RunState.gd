extends State

func EnterState():
	Player.animation.play("Run")
	print("Entered Run State")

func ExitState():
	print("Exited Run State")

func Update(_delta: float) -> void:	
	var movement = Player.GetInputMovement()
	
	if ActionType.is_falling(Player):
		transitioned.emit("Fall")
	elif ActionType.can_jump(Player):
		transitioned.emit("Jump")
	elif ActionType.can_roll(Player):
		transitioned.emit("Roll")
	elif ActionType.no_movement(movement):
		transitioned.emit("Idle")

func PhysicsUpdate(delta: float) -> void:
	var input_dir = Player.GetInputMovement()
	var direction = Player.GetDirection()
	Player.HandleHorizontalMovement(direction, delta)
	Player.HandleGravity(delta)
	Player.SetAnimation(input_dir)
	Player.move_and_slide()
