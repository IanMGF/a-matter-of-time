extends PlayerControl

@onready var camera: Camera3D = $CharacterBody3D/XROrigin/XRCamera3D

const SENSITIVITY = 0.001
const VIEW_EPSILON = 0

const MAX_PITCH = PI/2 - VIEW_EPSILON

func _ready() -> void:
	$CharacterBody3D/XROrigin/LeftHand.queue_free()
	$CharacterBody3D/XROrigin/RightHand.queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_gun_facing() -> Vector3:
	var viewport_size = get_viewport().size
	var screen_center = viewport_size / 2
	var vec = camera.project_ray_normal(screen_center)
	
	return vec

func get_gun_origin() -> Vector3:
	return camera.global_position

func get_camera() -> Camera3D:
	return camera

func is_holding() -> bool:
	return Input.is_key_pressed(KEY_Q)

func get_movement_direction() -> Vector2:
	var cam_rotation = get_camera().global_rotation.y
	var velocity = Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	var unitary = velocity.rotated(cam_rotation)
	return Vector2(unitary.x, -unitary.y)


func get_speed() -> float:
	return 70

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var delta = event.relative
		camera.global_rotation.y -= delta.x * SENSITIVITY
		camera.global_rotation.x = clamp(camera.global_rotation.x - delta.y * SENSITIVITY, -MAX_PITCH, MAX_PITCH)
