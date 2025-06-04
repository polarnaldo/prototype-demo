extends Control

func _process(_delta: float) -> void:
	$Label3D.text = str("FPS - ", Engine.get_frames_per_second())
