extends PlayerControl

@onready var camera: Camera3D = $CharacterBody3D/XROrigin/XRCamera3D

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
	print(cam_rotation, "R")
	var velocity = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var unitary = velocity.rotated(cam_rotation)
	print(unitary)
	return Vector2(unitary.x, -unitary.y)


func get_speed() -> float:
	return 35
