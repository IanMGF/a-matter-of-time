extends Node3D

func _ready() -> void:
	var door = $Door
	while true:
		door.open_door()
		await get_tree().create_timer(2).timeout
		door.close_door()
		await get_tree().create_timer(2).timeout
