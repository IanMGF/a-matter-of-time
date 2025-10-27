extends Node3D

var tween: Tween = null

@onready var attraction_area: Area3D = $Area3D
@onready var target_point: Node3D = %TargetPoint

var locked_object = null

func on_enter_area(body: RigidBody3D):
	if not is_instance_of(body, RigidBody3D):
		return
	
	if tween:
		tween.kill()
	
	locked_object = body
	
	# Calculate target rotation
	var single_axis_deviation = body.global_rotation.y - self.global_rotation.y
	var any_axis_deviation = fmod(single_axis_deviation + PI / 4, (PI / 2)) - PI / 4
	var target_angles = Vector3(body.global_rotation)
	
	target_angles.x = 0
	target_angles.y -= any_axis_deviation
	target_angles.z = 0
	
	# Initiate tweens
	tween = create_tween()
	tween.set_parallel(true)
	tween.bind_node(body)
	body.linear_velocity = Vector3.ZERO
	tween.tween_property(body, "global_position", target_point.global_position, 1.5) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(body, "rotation", target_angles, 1.5) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_CUBIC)

func on_leave_area(body: PhysicsBody3D):
	if body == locked_object:
		locked_object = null
	if tween:
		tween.kill()

func _ready() -> void:
	attraction_area.body_entered.connect(on_enter_area)
	attraction_area.body_exited.connect(on_leave_area)

func _aphysics_process(delta: float) -> void:
	var overlapping_bodies: Array[Node3D] = attraction_area.get_overlapping_bodies()
	
	# TODO: If object isn't of a specific type (word block), attraction should not happen
	
	for body_node: Node3D in overlapping_bodies:
		if not is_instance_of(body_node, RigidBody3D):
			continue

		var body: RigidBody3D = body_node

		var rel_position = target_point.global_position - body.global_position
		body.global_position += min(1, delta * 5) * rel_position

		var single_axis_deviation = body.global_rotation.y - self.global_rotation.y
		var any_axis_deviation = fmod(single_axis_deviation + PI / 4, (PI / 2)) - PI / 4

		body.global_rotation.y -= any_axis_deviation * delta * 5
		body.global_rotation.x *= 0
		body.global_rotation.z *= 0
 
