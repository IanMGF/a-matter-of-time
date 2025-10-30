@abstract
extends Node3D

class_name PlayerControl

@onready var character_body: CharacterBody3D = $CharacterBody3D
@export var interact_range: float

signal move(direction: Vector2)
signal rotate_obj(angle: float)
signal rotate_head(rotation: Vector3)
signal interact(target: Node3D)
signal grab(target: Node3D)
signal release()

func _physics_process(delta: float) -> void:
	character_body.move_and_slide()
	var direction = self.get_movement_direction()
	character_body.velocity.x = direction.x * delta * get_speed()
	character_body.velocity.z = direction.y * delta * get_speed()

@abstract
func get_gun_facing() -> Vector3

@abstract
func get_gun_cast_origin() -> Vector3

@abstract
func get_gun_geometric_origin() -> Vector3

@abstract
func get_camera() -> Camera3D

@abstract
func is_holding() -> bool

@abstract
func get_movement_direction() -> Vector2

@abstract
func get_speed() -> float

func attempt_grab() -> void:
	var ray_origin = self.get_gun_cast_origin()
	var ray_direction = self.get_gun_facing()
	var ray_end = ray_origin + ray_direction * self.interact_range
	
	var raycast = PhysicsRayQueryParameters3D.new()
	raycast.from = ray_origin
	raycast.to = ray_end
	raycast.collide_with_bodies = true
	raycast.collide_with_areas = true
	raycast.collision_mask = 1
	
	var space_state = get_tree().root.get_world_3d().direct_space_state
	var result = space_state.intersect_ray(raycast)
	
	if !result:
		return
	
	var collider = result.collider
	
	if not collider.is_in_group("Grabbable"):
		return
	
	grab.emit(collider)
