extends Node3D

@export var attraction: float = 1.0

@onready var attraction_area: Area3D = $Area3D
@onready var target_point: Node3D = %TargetPoint

func _physics_process(delta: float) -> void:
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
