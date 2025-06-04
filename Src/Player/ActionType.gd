class_name ActionType

static func has_movement(movement: Vector2) -> bool:
	return movement != Vector2.ZERO

static func no_movement(movement: Vector2) -> bool:
	return movement == Vector2.ZERO

static func is_falling(player: CharacterBody3D) -> bool:
	return player.velocity.y < 0 and not player.is_on_floor()

static func can_jump(player: CharacterBody3D) -> bool:
	return Input.is_action_just_pressed(InputAction.JUMP) and player.is_on_floor()

static func can_roll(player: CharacterBody3D) -> bool:
	return Input.is_action_just_pressed(InputAction.ROLL) and player.is_on_floor()
