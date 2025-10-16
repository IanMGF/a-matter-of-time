extends Node3D

@onready var xr_controller_left: XRController3D = $CharacterBody3D/XROrigin/LeftHand
@onready var xr_controller_right: XRController3D = $CharacterBody3D/XROrigin/RightHand
@onready var character_body: CharacterBody3D = $CharacterBody3D
@onready var camera: XRCamera3D = $CharacterBody3D/XROrigin/XRCamera3D

@export var level: Node3D
@export var prompt: Control
@export var interact_range: float

@onready var interact_ray_query = PhysicsRayQueryParameters3D.new()

var controller_position: Vector2

func input_controller_movement(_name: String, value: Vector2) -> void:
	controller_position = value

func left_controller_button_pressed(_name: String) -> void:
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
	
	var space_state = level.get_world_3d().direct_space_state
	var result = space_state.intersect_ray(interact_ray_query)

	if !result:
		return
		
	var collider: Node3D = result.collider
	if !collider.is_in_group("Breakable"):
		return
	
	collider.get_parent().queue_free()


func _ready() -> void:
	xr_controller_left.input_vector2_changed.connect(input_controller_movement)
	xr_controller_left.button_pressed.connect(left_controller_button_pressed)
	character_body.velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	character_body.move_and_slide()
	var cam_rotation = camera.global_rotation.y
	var unitary = controller_position.rotated(cam_rotation)
	character_body.velocity.x = unitary.x * delta * 100
	character_body.velocity.z = -unitary.y * delta * 100

func _process(_delta):
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

	var space_state = level.get_world_3d().direct_space_state
	var result = space_state.intersect_ray(interact_ray_query)
	
	if !result:
		prompt.visible = false
		return
	
	var collider: Object = result.collider
	if !collider.is_in_group("Breakable"):
		prompt.visible = false
		return
	
	prompt.visible = true
	prompt.set_position(camera.unproject_position(result.collider.global_position), true)
