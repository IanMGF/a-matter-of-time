extends Control

@onready var player: Node3D = %Player
@onready var interact_ray_query = PhysicsRayQueryParameters3D.new()

func _process(_delta: float) -> void:
	var camera = player.camera
	
	var viewport_size = get_viewport().size
	var screen_center = viewport_size / 2
	
	var ray_origin = camera.project_ray_origin(screen_center)
	var ray_direction = camera.project_ray_normal(screen_center)
	var ray_end = ray_origin + ray_direction * player.interact_range
	
	interact_ray_query.collide_with_areas = true
	interact_ray_query.collision_mask = 2
	interact_ray_query.from = ray_origin
	interact_ray_query.to = ray_end
	
	
	var space_state = camera.get_world_3d().direct_space_state
	var result = space_state.intersect_ray(interact_ray_query)
	
	if !result:
		self.visible = false
		return
	
	var collider: Object = result.collider
	
	player.popup_xr.global_position = (ray_origin + 2 * ray_end) / 3
	player.popup_xr.rotation = camera.rotation
	player.popup_xr.rotation.z = 0
	
	if !collider.is_in_group("Breakable"):
		self.visible = false
		return
	
	self.visible = true
