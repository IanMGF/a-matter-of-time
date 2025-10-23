extends PlayerControl

@onready var xr_controller_left: XRController3D = $CharacterBody3D/XROrigin/LeftHand
@onready var xr_controller_right: XRController3D = $CharacterBody3D/XROrigin/RightHand
@onready var camera: XRCamera3D = $CharacterBody3D/XROrigin/XRCamera3D
@onready var origin: XROrigin3D = $CharacterBody3D/XROrigin
@onready var hitbox: CollisionShape3D = $CharacterBody3D/CollisionShape3D

@export var popup_xr: OpenXRCompositionLayer
@export var prompt: Control
@export var layer_viewport: SubViewport

@onready var interact_ray_query = PhysicsRayQueryParameters3D.new()
@onready var composition = $CharacterBody3D/XROrigin/OpenXRCompositionLayerQuad

var controller_position: Vector2

func input_controller_movement(_name: String, value: Vector2) -> void:
	controller_position = value

func left_controller_button_pressed(btn_name: String) -> void:
	if btn_name == "trigger_click":
		var viewport_size = get_viewport().size
		var screen_center = viewport_size / 2

		var ray_origin = camera.project_ray_origin(screen_center)
		var ray_direction = camera.project_ray_normal(screen_center)

		var ray_end = ray_origin + ray_direction * interact_range

		interact_ray_query.collide_with_bodies = true
		interact_ray_query.collide_with_areas = true
		interact_ray_query.collision_mask = 2
		interact_ray_query.from = ray_origin
		interact_ray_query.to = ray_end

		#popup_xr.global_position = (ray_origin + 2 * ray_end) / 3
		#popup_xr.rotation = camera.rotation

		var space_state = get_tree().root.get_world_3d().direct_space_state
		var result = space_state.intersect_ray(interact_ray_query)

		if !result:
			return

		var collider: Node3D = result.collider

		self.interact.emit(collider)

func _process(delta: float) -> void:
	var hitbox_2d_pos = Vector2(hitbox.global_position.x, hitbox.global_position.z)
	var camera_2d_pos = Vector2(camera.global_position.x, camera.global_position.z)
	
	var distance = hitbox_2d_pos.distance_to(camera_2d_pos)
	if distance < 0.2:
		camera.set_cull_mask_value(1, true)
		camera.set_perspective(75.0, 0.01, 4000)
		return

	camera.set_cull_mask_value(1, false)
	camera.set_orthogonal(1440, 0.01, 4000)
	camera.fov = 2.0

func right_controller_button_pressed(_btn_name: String) -> void:
	pass

func _ready() -> void:
	composition.layer_viewport = layer_viewport
	xr_controller_left.input_vector2_changed.connect(input_controller_movement)
	xr_controller_left.button_pressed.connect(left_controller_button_pressed)
	xr_controller_right.button_pressed.connect(right_controller_button_pressed)
	character_body.velocity = Vector3.ZERO

	var left_hand_mesh = $CharacterBody3D/XROrigin/LeftHand/MeshInstance3D
	var right_hand_mesh = $CharacterBody3D/XROrigin/RightHand/MeshInstance3D

	var hands_scale_scalar = origin.world_scale * 0.1
	var hands_scale_vector = Vector3(hands_scale_scalar, hands_scale_scalar, hands_scale_scalar)
	left_hand_mesh.scale = hands_scale_vector
	right_hand_mesh.scale = hands_scale_vector

func get_gun_facing() -> Vector3:
	return xr_controller_right.global_rotation

func get_gun_origin() -> Vector3:
	return xr_controller_right.global_position

func get_camera() -> Camera3D:
	return camera

func is_holding() -> bool:
	return xr_controller_right.is_pressed("trigger") || xr_controller_right.is_pressed("grasp")

func get_movement_direction() -> Vector2:
	var cam_rotation = xr_controller_left.global_rotation.y
	var unitary = controller_position.rotated(cam_rotation)

	return Vector2(unitary.x, -unitary.y)

func get_speed() -> float:
	return 15 * origin.world_scale
