extends Node

@onready var player: PlayerControl = get_parent()

@onready var popup: Sprite3D = $Popup
var camera: Camera3D
var viewport: Viewport
var interact_range: float

func _ready():
	viewport = get_viewport()
	interact_range = player.interact_range

func _process(_delta: float) -> void:
	camera = player.get_camera()
	var screen_center = Vector2(viewport.size.x / 2, viewport.size.y / 2)
	var origin_point = camera.global_position
	var normal = camera.project_ray_normal(screen_center)

	var raycast = PhysicsRayQueryParameters3D.new()
	raycast.from = origin_point
	raycast.to = origin_point + normal * interact_range
	raycast.collide_with_bodies = true
	raycast.collide_with_areas = true

	var space_state = get_tree().root.get_world_3d().direct_space_state
	var result = space_state.intersect_ray(raycast)

	if !result:
		popup.visible = false
	else:
		popup.visible = true
		popup.global_position = result.collider.global_position
