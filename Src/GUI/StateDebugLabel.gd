extends Label3D

@export var state_machine: StateMachine

func _process(_delta: float) -> void:
	if state_machine and state_machine.current_state:
		text = "State: " + state_machine.current_state.name
