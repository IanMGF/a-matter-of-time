extends Node3D

@export var time_block : RigidBody3D

func _ready() -> void:
	time_block.mass = time_block.mass * 5
	time_block.gravity_scale = time_block.gravity_scale / 5
