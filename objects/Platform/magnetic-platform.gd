extends Node3D

var tween: Tween = null

@onready var attraction_area: Area3D = $Area3D
@onready var target_point: Node3D = %TargetPoint
@onready var timer: Timer = $Timer
@onready var particles: CPUParticles3D = $AreaParticles

var locked_object = null

func on_enter_area(body: PhysicsBody3D):
	if not body.is_in_group("WordCube"):
		return

	if locked_object != null:
		return

	_lock_object(body)

func on_leave_area(body: PhysicsBody3D):
	if body == locked_object:
		locked_object = null
	if tween:
		tween.stop()
		tween.kill()

	for obj in attraction_area.get_overlapping_bodies():
		if not obj.is_in_group("WordCube"):
			continue

		_lock_object(obj)
		break

func _ready() -> void:
	attraction_area.body_entered.connect(on_enter_area)
	attraction_area.body_exited.connect(on_leave_area)
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	if locked_object == null:
		return

	if tween:
		return

	_lock_object(locked_object)

func _lock_object(body: PhysicsBody3D):
	locked_object = body

	if tween != null and tween.is_valid():
		tween.stop()
		tween.kill()

	# Calculate target rotation
	var single_axis_deviation = body.global_rotation.y - self.global_rotation.y
	var any_axis_deviation = fmod(single_axis_deviation + PI / 4, (PI / 2)) - PI / 4
	var target_angles = Vector3(body.global_rotation)

	target_angles.x = 0
	target_angles.y -= any_axis_deviation
	target_angles.z = 0

	# Initiate tweens
	tween = body.create_tween()
	tween.set_parallel(true)
	body.linear_velocity = Vector3.ZERO
	body.angular_velocity = Vector3.ZERO

	tween.tween_property(body, "global_position", target_point.global_position, 1.5) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(body, "global_rotation", target_angles, 1.5) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_CUBIC)

func _physics_process(delta: float) -> void:
	print("OBJ:", self.get_instance_id(), " LOCKED:", locked_object)
	for obj: Node3D in attraction_area.get_overlapping_bodies():
		if obj == locked_object:
			continue
		if not is_instance_of(obj, RigidBody3D):
			continue
		if not obj.is_in_group("WordCube"):
			continue

		var rigid_body = obj as RigidBody3D
		var direction = (rigid_body.global_position - target_point.global_position).normalized()
		var impulse = direction * 3 * 60 * delta
		rigid_body.apply_force(impulse, Vector3.ZERO)
