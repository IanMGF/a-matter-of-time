extends Node3D

@export var player_node : PlayerControl

func _ready() -> void:
	while(true):
		player_node.attempt_grab()
		await get_tree().create_timer(3).timeout
		player_node.release.emit()
		await get_tree().create_timer(1).timeout
