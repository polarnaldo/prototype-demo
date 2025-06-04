extends State

func EnterState() -> void:
	if Player: Player.animation.play("Idle")
	print("Entered Idle State")

func ExitState() -> void:
	print("Exited Idle State")

func Update(_delta: float) -> void:
	var movement = Player.GetInputMovement()
	
	if ActionType.is_falling(Player):
		transitioned.emit("Fall")
	elif ActionType.can_jump(Player):
		transitioned.emit("Jump")
	elif ActionType.can_roll(Player):
		transitioned.emit("Roll")
	elif ActionType.has_movement(movement):
		transitioned.emit("Run")

func PhysicsUpdate(delta: float) -> void:
	Player.HandleHorizontalMovement(Vector3.ZERO, delta)
	Player.HandleGravity(delta)
	Player.move_and_slide()
