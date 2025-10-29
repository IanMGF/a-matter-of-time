extends Node
@onready var player_node : PlayerControl = self.get_parent()
@onready var grab_object : Node3D = null

func object_grabbed(collider : Node3D) -> void:
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
	
	if grab_object.global_position.distance_to(target_position) <= 0.1:
		return
	
	if not is_instance_of(grab_object, RigidBody3D):
		return
	
	var rigid_grabbed_object : RigidBody3D = grab_object
	
	var force_direction = (target_position - grab_object.global_position).normalized()
	var force = force_direction * delta * 1500 * target_position.distance_to(grab_object.global_position)
	rigid_grabbed_object.apply_force(force)
		
