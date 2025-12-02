extends CSGCombiner3D

@onready var mirror = $StaticBody3D
@onready var affected_area = $Area3D
@onready var reflection: Node3D = $PlayerReflection
var model: MeshInstance3D = null

func _process(delta: float) -> void:
	var bodies = affected_area.get_overlapping_bodies()
	var in_area = false
	for body in bodies:
		if not (body is CharacterBody3D):
			continue
		var difference = body.global_position.x - mirror.global_position.x
		reflection.global_position = body.global_position
		reflection.global_position.x = mirror.global_position.x - difference
		
		var camera = body.get_node("XROrigin/Camera")
		reflection.global_rotation.y = -camera.global_rotation.y
		#var rh = body.get_node("XROrigin/RightHand")


func on_enter(body: CharacterBody3D):
	if body is CharacterBody3D and model == null:
		model = body.get_node("Model")
