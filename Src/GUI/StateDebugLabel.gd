extends Label3D

@export var player: MainPlayer

func _process(delta: float) -> void:
	if player and player.currentState:
		text = "State: " + player.currentState.name
