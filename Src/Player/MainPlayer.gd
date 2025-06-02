extends CharacterBody3D
class_name MainPlayer

#region Player Variables

@onready var pivot: Node3D = $CameraHolder
@onready var gridmap: GridMap = $"../GridMap"
@onready var camera_player: Camera3D = $CameraHolder/Camera3D
@onready var animated_sprite_3d: Sprite3D = $Sprite3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var States: Node = $StateMachine

var camera_rotation_target: Vector3
var camera_position: int = 0
var is_rolling: bool = false
var can_roll: bool = true
var coyote_timer: float = 0.0

const SPEED: float = 2
const JUMP_SPEED: float = 4
const GRAVITY: float = -9.8
const ROLL_SPEED: float = 3 
const ROLL_DURATION: float = 0.5
const COYOTE_TIME: float = 10.1

#endregion

#region State Machine Variables

var currentState: State = null
var previousState: State = null

#endregion

#region Main Loop Functions

func _ready():
	for state in States.get_children():
		if state is State:
			state.States = States
			state.Player = self
	previousState = States.get_node("Idle")
	currentState = States.get_node("Idle")
	currentState.EnterState()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		camera_position = ChangeCameraRotation(camera_position, 90.0, 1)
	if event.is_action_pressed("attack2"):
		camera_position = ChangeCameraRotation(camera_position, -90.0, 3)

func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction: Vector3 = (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor() and Input.is_action_just_pressed("roll") and can_roll:
		changeState(States.get_node("Roll"))

	if Input.is_action_just_pressed("ui_accept") and coyote_timer > 0:
		changeState(States.get_node("Jump"))

	if not is_rolling:
		HandleHorizontalMovement(direction)

	if currentState != null:
		currentState.Update(delta)

	# Handle gravity
	HandleCoyoteTime(delta) 
	HandleGravity(delta)

	# Handle animations
	HandleAnimation(direction)
	SetAnimation(input_dir)

	move_and_slide()

func changeState(newState: State):
	if newState != null and newState != currentState:
		currentState.ExitState()
		previousState = currentState
		currentState = newState
		currentState.EnterState()

#endregion

#region Custom Functions

func HandleHorizontalMovement(direction: Vector3) -> void:
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

func HandleCoyoteTime(delta: float) -> void:
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

func HandleGravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func HandleAnimation(direction: Vector3) -> void:
	if is_rolling:
		return

	if not is_on_floor():
		if velocity.y > 0:
			animation_player.play("Fall")
		elif velocity.y < 0:
			animation_player.play("Jump")
	else:
		if direction:
			animation_player.play("Run")
		else:
			animation_player.play("Idle")

func SetAnimation(input_dir: Vector2) -> void:
	if input_dir.x < 0: 
		animated_sprite_3d.flip_h = true
	elif input_dir.x > 0: 
		animated_sprite_3d.flip_h = false

func ChangeCameraRotation(current_position, angle_delta, increment):
	var new_rotation: Vector3 = camera_rotation_target + Vector3(0, angle_delta, 0)
	var tween := get_tree().create_tween()
	tween.tween_property(pivot, "rotation_degrees", new_rotation, 0.3)
	camera_rotation_target = new_rotation
	return (current_position + increment) % 4

#endregion

#region Beta Functions

func is_on_back3(player: Node3D, camera: Camera3D) -> bool:
	var space_state = player.get_world_3d().direct_space_state

	var from = camera.global_transform.origin
	var to = player.global_transform.origin

	var query = PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to = to
	query.exclude = [player]

	var result = space_state.intersect_ray(query)

	if result:
		return true
	return false

# ==================================================

# = CÓDIGO POSICIÓN = 
#	var current_cell = find_current_grid_block()  # Encuentra la celda actual

#	# is_on_wall()
#	# is_on_floor()
#	# is_on_ceiling()
#	is_on_background(self, camera_player)
#	if current_cell != previous_cell:  # Solo actualizar si la celda ha cambiado
#		previous_cell = current_cell  # Guardar la nueva celda
#		var longest_cell = find_closest_grid_position(current_cell, camera_position)
#		
#		# Actualizar el GridMap solo si es necesario
#		#gridmap.set_cell_item(longest_cell, 1, 0)
#		
#		# Obtener la posición en el mundo real y mover al personaje
#		var global_position = gridmap.map_to_local(longest_cell)
#
#		global_position.y += gridmap.cell_size.y  # Asegurar que esté sobre el bloque
#		print(global_position)
#
#		self.global_transform.origin = global_position

	

	#change_blocks_color_in_front()
	
	#var floorDistance = test_and_collide(self, is_on_floor(), delta)
	#try_correct_depth(self, floorDistance)
	#var corrected_transform = try_correct_depth(self, distance_to_correct)
	#global_transform = corrected_transform
		# Detectar si se puede rodar

# Variable for adjusting the z-position of the target
var z_position_target: float = 0.0

# Variables for detecting the current gridmap block
var NORMAL_BLOCK_ID: int = 0
var HIGHLIGHT_BLOCK_ID: int = 1
var previous_cell: Vector3i = Vector3i(-1, -1, -1)

var previous_cell_1 = Vector3i(-999, -999, -999)  # Un valor imposible inicial

func find_current_grid_block() -> Vector3i:
	var current_cell: Vector3i = gridmap.local_to_map(global_position)
	var check_cell: Vector3i = current_cell
	var cell_item: int = gridmap.get_cell_item(check_cell)
	var min_y: int = -100  # Límite inferior de búsqueda

	while cell_item == -1 and check_cell.y >= min_y:
		check_cell.y -= 1
		cell_item = gridmap.get_cell_item(check_cell)

	if check_cell.y < min_y:  
		var fallback_cell: Vector3i = current_cell + Vector3i(0, -1, 0)
		return fallback_cell  # Retorna una posición válida en caso de no encontrar bloque
	
	return check_cell  # Retorna la posición del bloque encontrado

func find_closest_grid_position(current_cell: Vector3i, current_position: int) -> Vector3i:
	var longest_cell: Vector3i = current_cell
	var longest_cell_def: Vector3i = current_cell
	var cell_item: int = gridmap.get_cell_item(longest_cell)
	var limits := {
		"x": {"min": -100, "max": 100},
		"z": {"min": -100, "max": 100}
	}
	
	var directions := {
		0: Vector3i(0, 0, 1),  # +Z
		1: Vector3i(1, 0, 0),  # +X
		2: Vector3i(0, 0, -1), # -Z
		3: Vector3i(-1, 0, 0)  # -X
	}
	
	if current_position in directions:
		var dir = directions[current_position]
		var axis = "x" if dir.x != 0 else "z"
		
		while longest_cell[axis] < limits[axis]["max"]:
			cell_item = gridmap.get_cell_item(longest_cell)
			if cell_item == -1:
				break
			longest_cell += dir
		
		while longest_cell[axis] > limits[axis]["min"]:
			cell_item = gridmap.get_cell_item(longest_cell)
			if cell_item == -1:
				longest_cell -= dir
				break
			longest_cell -= dir
	
	return longest_cell if cell_item == -1 else longest_cell_def

#endregion
