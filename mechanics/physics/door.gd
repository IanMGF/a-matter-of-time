extends Node3D

var door_tween: Tween

func open_door() -> void:
	if door_tween:
		door_tween.kill()
	door_tween = get_tree().create_tween()
	door_tween.set_parallel(true)
	door_tween \
	.tween_property($door_a, "position", Vector3(1.5, 0, 0), 0.75) \
	.set_ease(Tween.EASE_IN_OUT) \
	.set_trans(Tween.TRANS_CUBIC)
	door_tween \
	.tween_property($door_b, "position", Vector3(-1.5, 0, 0), 0.75) \
	.set_ease(Tween.EASE_IN_OUT) \
	.set_trans(Tween.TRANS_CUBIC)

func close_door() -> void:
	if door_tween:
		door_tween.kill()
	door_tween = get_tree().create_tween()
	door_tween.set_parallel(true)
	door_tween \
	.tween_property($door_a, "position", Vector3(0, 0, 0), 0.75) \
	.set_ease(Tween.EASE_IN_OUT) \
	.set_trans(Tween.TRANS_CUBIC)
	door_tween \
	.tween_property($door_b, "position", Vector3(0, 0, 0), 0.75) \
	.set_ease(Tween.EASE_IN_OUT) \
	.set_trans(Tween.TRANS_CUBIC)
