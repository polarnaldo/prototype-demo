extends CharacterBody3D
class_name MainPlayer

#region Player Variables

@onready var pivot: Node3D = $CameraHolder
@onready var gridmap: GridMap = $"../GridMap"
@onready var camera: Camera3D = $CameraHolder/Camera3D
@onready var animated_sprite_3d: Sprite3D = $Sprite3D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var state_machine: Node = $StateMachine

var camera_rotation_target: Vector3
var camera_position: int = 0
var coyote_timer: float = 0.0

@export var SPEED: float = 1
@export var JUMP_SPEED: float = 3
@export var GRAVITY: float = -5.0
@export var ROLL_SPEED: float = 1.5
@export var ROLL_DURATION: float = 0.5
@export var COYOTE_TIME: float = 10.0

#region L/R MOVEMENT
@export_category("L/R Movement")
@export_range(50, 500) var maxSpeed: float = 200.0
@export_range(0, 4) var timeToReachMaxSpeed: float = 0.1
@export_range(0, 4) var timeToReachZeroSpeed: float = 0.1
@export var directionalSnap: bool = false
var acceleration: float = SPEED / timeToReachMaxSpeed
var deceleration: float = SPEED / timeToReachZeroSpeed
#endregion

#region JUMPING AND GRAVITY
@export_category("Jumping and Gravity")
##The peak height of your player's jump
@export_range(0, 20) var jumpHeight: float = 2.0
##How many jumps your character can do before needing to touch the ground again. Giving more than 1 jump disables jump buffering and coyote time.
@export_range(0, 4) var jumps: int = 1
##The strength at which your character will be pulled to the ground.
@export_range(0, 100) var gravityScale: float = 20.0
##The fastest your player can fall
@export_range(0, 1000) var terminalVelocity: float = 500.0
##Your player will move this amount faster when falling providing a less floaty jump curve.
@export_range(0.5, 3) var descendingGravityFactor: float = 1.3
##Enabling this toggle makes it so that when the player releases the jump key while still ascending, their vertical velocity will cut by the height cut, providing variable jump height.
@export var shortHopAkaVariableJumpHeight: bool = true
##How much the jump height is cut by.
@export_range(1, 10) var jumpVariable: float = 2
##How much extra time (in seconds) your player will be given to jump after falling off an edge. This is set to 0.2 seconds by default.
@export_range(0, 0.5) var coyoteTime: float = 0.2
##The window of time (in seconds) that your player can press the jump button before hitting the ground and still have their input registered as a jump. This is set to 0.2 seconds by default.
@export_range(0, 0.5) var jumpBuffering: float = 2.2
var jump_buffer_timer: float = 0.0
var jump_pressed: bool = false

#endregion

#endregion

#region Main Loop Functions

func _ready():
	for state in state_machine.get_children():
		if state is State:
			state.Player = self
			state.States = state_machine

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		camera_position = ChangeCameraRotation(camera_position, 90.0, 1)
	if event.is_action_pressed("attack2"):
		camera_position = ChangeCameraRotation(camera_position, -90.0, 3)

func _physics_process(delta: float) -> void:
	if state_machine.current_state:
		state_machine.current_state.PhysicsUpdate(delta)

#endregion

#region Custom Functions

func HandleHorizontalMovement(input_dir: Vector3, delta: float) -> void:
	var target = input_dir * SPEED
	
	if input_dir.x == 0:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, target.x, acceleration * delta)
	
	if input_dir.z == 0:
		velocity.z = move_toward(velocity.z, 0, deceleration * delta)
	else:
		velocity.z = move_toward(velocity.z, target.z, acceleration * delta)

func HandleCoyoteTime(delta: float) -> void:
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

func HandleGravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

func SetAnimation(input_dir: Vector2) -> void:
	if input_dir.x < 0: 
		animated_sprite_3d.flip_h = true
	elif input_dir.x > 0: 
		animated_sprite_3d.flip_h = false

func ChangeCameraRotation(current_position, angle_delta, increment) -> int:
	var new_rotation: Vector3 = camera_rotation_target + Vector3(0, angle_delta, 0)
	var tween := get_tree().create_tween()
	tween.tween_property(pivot, "rotation_degrees", new_rotation, 0.3)
	camera_rotation_target = new_rotation
	return (current_position + increment) % 4

func GetDirection() -> Vector3:
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	return (pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
func GetInputMovement() -> Vector2:
	return (Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"))

#endregion
