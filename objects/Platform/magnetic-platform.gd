extends Node3D

var tween: Tween = null

@onready var attraction_area: Area3D = $Area3D
@onready var target_point: Node3D = %TargetPoint

var locked_object = null

func on_enter_area(body: RigidBody3D):
	if not body.is_in_group("WordCube"):
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
	tween.tween_property(body, "global_rotation", target_angles, 1.5) \
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
