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
	var pressing_bodies = cap_area.get_overlapping_bodies()
	if pressing_bodies.size() == 2:
		pressed.emit()

func on_body_exited(_body):
	cap_mesh.position = Vector3.ZERO
	var pressing_bodies = cap_area.get_overlapping_bodies()
	if pressing_bodies.size() <= 1:
		released.emit()

signal pressed()
signal released()
