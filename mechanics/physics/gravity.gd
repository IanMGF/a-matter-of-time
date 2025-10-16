extends RigidBody3D

func _physics_process(delta: float) -> void:
	self.apply_force(get_gravity())
	self.get_parent_node_3d().global_position = self.global_position
	self.position = Vector3(0, 0, 0)
