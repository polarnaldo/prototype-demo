extends Control

func _process(delta: float) -> void:
	$Label3D.text = str("FPS - ", Engine.get_frames_per_second())
