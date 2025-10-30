extends Node3D

@export var player_node : PlayerControl

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			player_node.attempt_grab()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			player_node.release.emit()
