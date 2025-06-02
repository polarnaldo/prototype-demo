# Roll.gd
extends State

var roll_timer := 0.0

func EnterState():
	print("Entered Roll State")
	Player.animation_player.play("Roll")
	Player.is_rolling = true
	Player.can_roll = false
	roll_timer = Player.ROLL_DURATION

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = (Player.pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

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
	print("Exited Roll State")
	Player.is_rolling = false
	Player.can_roll = true

func Update(delta: float) -> void:
	roll_timer -= delta
	if roll_timer <= 0:
		if not Player.is_on_floor():
			Player.changeState(States.get_node("Fall"))
		else:
			Player.changeState(States.get_node("Idle"))
