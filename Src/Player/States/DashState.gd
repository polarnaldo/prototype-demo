extends State

var roll_timer : float = 0.0

func EnterState():
	print("Entered Dash State")
	
	roll_timer = 0.2
	Player.velocity.y = 0
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

func ExitState():
	print("Exited Dash State")

func Update(delta: float) -> void:
	Player.animation.play("Idle")
	roll_timer -= delta
	if roll_timer <= 0.0:
		if not Player.is_on_floor():
			transitioned.emit("Fall")
		else:
			transitioned.emit("Idle")

func PhysicsUpdate(delta: float) -> void:
	Player.move_and_slide()
