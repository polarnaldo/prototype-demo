extends State

func EnterState():
	Player.animation.play("Fall")
	print("Entered Fall State")

func ExitState():
	print("Exited Fall State")

func Update(_delta: float) -> void:
	var movement = Player.GetInputMovement()
	
	if Player.is_on_floor():
		if ActionType.no_movement(movement):
			transitioned.emit("Idle")
		elif ActionType.has_movement(movement):
			transitioned.emit("Run")

func PhysicsUpdate(delta: float) -> void:
	var input_dir = Player.GetInputMovement()
	var direction = Player.GetDirection()
	Player.HandleHorizontalMovement(direction, delta)
	Player.HandleGravity(delta)
	Player.HandleCoyoteTime(delta)
	Player.SetAnimation(input_dir)
	Player.move_and_slide()
