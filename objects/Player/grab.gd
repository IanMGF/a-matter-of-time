extends Node
@onready var player_node : PlayerControl = self.get_parent()
@onready var grabbed_object : RigidBody3D = null
@onready var path: Path3D = $CSGPolygon3D/Path3D

@onready var previous_gravity = null

const ATTRACTION_FORCE_FACTOR = 750		# Increasing this makes the object move faster towards the player
const DRAG_FORCE_FACTOR = 200			# Increasing this removes exceeding forces faster

const ATTRACTION_FORCE_LIMIT = 750
const DRAG_FORCE_LIMIT = 200

func grab_object(collider : RigidBody3D) -> void:
	if grabbed_object or not is_instance_of(collider, RigidBody3D):
		return

	grabbed_object = collider
	previous_gravity = grabbed_object.gravity_scale
	grabbed_object.gravity_scale = 0

func release_object() -> void:
	if grabbed_object == null:
		return
	path.curve.clear_points()
	grabbed_object.gravity_scale = previous_gravity

	grabbed_object = null

func _ready() -> void:
	player_node.grab.connect(grab_object)
	player_node.release.connect(release_object)

func _physics_process(delta: float) -> void:
	if grabbed_object == null:
		return

	var target_position : Vector3 = player_node.get_gun_cast_origin() + player_node.get_gun_facing() * player_node.interact_range
	
	# Adjust position
	var attraction_force: Vector3 = target_position - grabbed_object.global_position
	attraction_force *= delta * ATTRACTION_FORCE_FACTOR * target_position.distance_to(grabbed_object.global_position)
	attraction_force = attraction_force.limit_length(ATTRACTION_FORCE_LIMIT)

	var drag_force: Vector3 = grabbed_object.linear_velocity * -DRAG_FORCE_FACTOR * delta
	drag_force = drag_force.limit_length(DRAG_FORCE_LIMIT)

	grabbed_object.apply_force(attraction_force + drag_force)

	# Adjust rotation
	var obj_rotation = grabbed_object.rotation
	var attraction_angle: Vector3 = Vector3.UP * -obj_rotation.y \
		+ Vector3.RIGHT * -obj_rotation.x \
		+ Vector3.BACK * -obj_rotation.z
	
	var ang_vel = grabbed_object.angular_velocity
	
	grabbed_object.apply_torque(attraction_angle * ATTRACTION_FORCE_FACTOR * delta)
	grabbed_object.apply_torque(-ang_vel * DRAG_FORCE_FACTOR * delta)

func _process(_delta: float) -> void:
	if grabbed_object == null:
		return
	
	var point_a: Vector3 = player_node.get_gun_geometric_origin()
	var point_i1: Vector3 = player_node.get_gun_geometric_origin() + player_node.get_gun_facing() * 0.1 * player_node.interact_range
	var point_e: Vector3 = grabbed_object.global_position

	var point_i2: Vector3 = point_a.lerp(point_i1, 0.6)
	var point_i3: Vector3 = point_e.lerp(point_i1, 0.6)

	var point_c: Vector3 = point_i2.lerp(point_i3, 0.5).lerp(point_i1, 0.5)
	var point_b: Vector3 = point_a.lerp(point_i1, 0.5)
	var point_d: Vector3 = point_e.lerp(point_i1, 0.5)

	path.curve.clear_points()
	path.curve.add_point(point_a)
	path.curve.add_point(point_b)
	path.curve.add_point(point_c)
	path.curve.add_point(point_d)
	path.curve.add_point(point_e)
