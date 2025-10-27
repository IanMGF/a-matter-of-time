extends Node3D

@onready var cap_area: Area3D = $DetectionArea
@onready var cap_mesh: Node3D = $Cap
@onready var base_body: StaticBody3D = $Base/BaseStaticBody

func _ready():
	cap_area.body_entered.connect(on_body_entered)
	cap_area.body_exited.connect(on_body_exited)
	pass

func on_body_entered(body):
	if body == base_body:
		return
	cap_mesh.position = Vector3(0, -0.125, 0)

func on_body_exited(_body):
	cap_mesh.position = Vector3.ZERO
