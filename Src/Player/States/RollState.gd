extends State

var RollTimer: float = 0.0

func EnterState():
	print("Entered Roll State")
	Player.animation.play("Roll")
	Roll()

func ExitState():
	print("Exited Roll State")

func Update(delta: float) -> void:
	RollTimer -= delta
	
	if RollTimer <= 0.0:
		if ActionType.is_falling(Player):
			transitioned.emit("Fall")
		else:
			transitioned.emit("Idle")

func PhysicsUpdate(delta: float) -> void:
	Player.HandleGravity(delta)
	Player.move_and_slide()

func Roll():
	RollTimer = Player.ROLL_DURATION

	var direction = Player.GetDirection()

	if direction != Vector3.ZERO:
		Player.velocity.x = direction.x * Player.ROLL_SPEED
		Player.velocity.z = direction.z * Player.ROLL_SPEED
	else:
		match Player.camera_position:
			0:
				Player.velocity.x = (-1 if Player.animated_sprite_3d.flip_h else 1) * Player.ROLL_SPEED
				Player.velocity.z = 0
			1:
				Player.velocity.x = 0
				Player.velocity.z = (1 if Player.animated_sprite_3d.flip_h else -1) * Player.ROLL_SPEED
			2:
				Player.velocity.x = (1 if Player.animated_sprite_3d.flip_h else -1) * Player.ROLL_SPEED
				Player.velocity.z = 0
			3:
				Player.velocity.x = 0
				Player.velocity.z = (-1 if Player.animated_sprite_3d.flip_h else 1) * Player.ROLL_SPEED
