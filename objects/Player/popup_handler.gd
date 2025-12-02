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
	if player.get_node("Grab").is_holding:
		popup.visible = false
		return
	
	camera = player.get_camera()
	player.get_node("CharacterBody3D/XROrigin/astronaut").global_rotation.y = camera.global_rotation.y
	var origin_point = camera.global_position
	var normal = player.get_gun_facing()

	var raycast = PhysicsRayQueryParameters3D.new()
	raycast.from = origin_point
	raycast.to = origin_point + normal * interact_range
	raycast.collide_with_bodies = true

	var space_state = get_tree().root.get_world_3d().direct_space_state
	var result = space_state.intersect_ray(raycast)

	if !result:
		popup.visible = false
		return
	
	if !result.collider.is_in_group("Grabbable"):
		popup.visible = false
		return
		
	raycast.from = origin_point
	raycast.to = result.collider.global_position
	raycast.collide_with_bodies = true
	
	var popup_place = space_state.intersect_ray(raycast)
	if popup_place:
		popup.global_position = popup_place.position
	else:
		popup.global_position = result.collider.global_position
	
	popup.visible = true
