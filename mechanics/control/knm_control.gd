extends PlayerControl

@onready var camera: Camera3D = $CharacterBody3D/XROrigin/XRCamera3D

func _ready() -> void:
	$CharacterBody3D/XROrigin/LeftHand.queue_free()
	$CharacterBody3D/XROrigin/RightHand.queue_free()

func get_gun_facing() -> Vector3:
	return camera.global_rotation

func get_gun_origin() -> Vector3:
	return camera.global_position

func get_camera() -> Camera3D:
	return camera

func is_holding() -> bool:
	return Input.is_key_pressed(KEY_Q)

func get_movement_direction() -> Vector2:
	var cam_rotation = get_camera().global_rotation.y
	var velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var unitary = velocity.rotated(cam_rotation)
	return Vector2(unitary.x, -unitary.y)


func get_speed() -> float:
	return 35
