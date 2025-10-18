extends Node3D

@export var attraction: float = 1.0

@onready var attraction_area: Area3D = $Area3D
@onready var target_point: Node3D = %TargetPoint

func _physics_process(delta: float) -> void:
	var overlapping_bodies: Array[Node3D] = attraction_area.get_overlapping_bodies()
	
	# If object isn't of a specific type, attraction should not happen
	
	for body_node: Node3D in overlapping_bodies:
		if not is_instance_of(body_node, RigidBody3D):
			continue
		var body: RigidBody3D = body_node
		var force_dir: Vector3 = (target_point.global_position - body.global_position).normalized()
		
		var distance: float = (target_point.global_position.distance_to(body.global_position))
		var force_magnitude: float = 100 / max(distance * distance * distance, 2.0)
		
		var force: Vector3 = force_dir * force_magnitude
		
		body.gravity_scale = 0.0
		body.apply_force(force)
		
		var vel_magnitude = body.linear_velocity.length()
		if vel_magnitude * delta > distance:
			var corrected = distance / delta
			body.linear_velocity = body.linear_velocity.normalized() * corrected * 1.5
