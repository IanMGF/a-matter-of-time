extends RigidBody3D

@export var new_speed: float = 0.5

func _physics_process(_delta):
	# 1. Get the rigid body's current velocity
	var current_velocity: Vector3 = linear_velocity

	# 2. Check if the body is actually moving
	# We check against a small number (epsilon) to avoid division by zero
	# if the velocity is (0, 0, 0).
	if current_velocity.length() > 0.0001:
		
		# 3. Get the direction by normalizing the velocity
		var direction: Vector3 = current_velocity.normalized()
		
		# 4. Set the linear_velocity to the direction multiplied by the new speed
		linear_velocity = direction * new_speed
