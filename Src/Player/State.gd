# PlayerState.gd
extends Node3D
class_name State

signal Transitioned(new_state_name: StringName)
#signal Transition(target_state_name: String)

var Player: CharacterBody3D = null
var States: Node3D = null

func EnterState() -> void:
	pass

func ExitState() -> void:
	pass

func Update(_delta: float) -> void:
	pass

func PhysicsUpdate(_delta: float) -> void:
	pass

func HandleInput(_event: InputEvent) -> void:
	pass
