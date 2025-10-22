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

func _physics_process(delta: float) -> void:
	character_body.move_and_slide()
	var direction = self.get_movement_direction()
	character_body.velocity.x = direction.x * delta * get_speed()
	character_body.velocity.z = direction.y * delta * get_speed()

@abstract
func get_gun_facing() -> Vector3

@abstract
func get_gun_origin() -> Vector3

@abstract
func get_camera() -> Camera3D

@abstract
func is_holding() -> bool

@abstract
func get_movement_direction() -> Vector2

@abstract
func get_speed() -> float
