# StateMachine.gd
extends Node3D
class_name StateMachine

@export var current_state: State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioned.connect(transition)
		else:
			push_warning("State machine contains child which is not 'State'")
			
	current_state.EnterState()

func _process(delta):
	current_state.Update(delta)
	
func _physics_process(delta):
	current_state.PhysicsUpdate(delta)
	
func transition(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	
	if new_state != null:
		if new_state != current_state:
			current_state.ExitState()
			new_state.EnterState()
			current_state = new_state
	else:
		push_warning("Called transition on a state that does not exist")
