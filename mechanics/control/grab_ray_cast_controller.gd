extends Node
@onready var player_node : PlayerControl = self.get_parent()
@onready var grab_object : Node3D = null

func object_grabbed(collider : RigidBody3D) -> void:
	if grab_object:
		return

	grab_object = collider
	if is_instance_of(grab_object, RigidBody3D):
		grab_object.gravity_scale = 0

func object_released() -> void:
	if is_instance_of(grab_object, RigidBody3D):
		grab_object.gravity_scale = 1

	grab_object = null

func _ready() -> void:
	player_node.grab.connect(object_grabbed)
	player_node.release.connect(object_released)

func _physics_process(delta: float) -> void:
	if !grab_object:
		return

	var target_position : Vector3 = player_node.get_gun_origin() + player_node.get_gun_facing() * player_node.interact_range

	if not is_instance_of(grab_object, RigidBody3D):
		return

	var rigid_grabbed_object : RigidBody3D = grab_object

	var attraction_force: Vector3 = target_position - rigid_grabbed_object.global_position
	attraction_force *= delta * 750 * target_position.distance_to(rigid_grabbed_object.global_position)

	var drag_force: Vector3 = rigid_grabbed_object.linear_velocity * -200 * delta

	rigid_grabbed_object.apply_force(attraction_force.limit_length(750) + drag_force.limit_length(200))
