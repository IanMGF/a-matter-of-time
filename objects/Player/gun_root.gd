extends Node3D

@export var gun_animation_player : AnimationPlayer
@onready var player_node : PlayerControl = self.get_parent().get_parent()

func _ready() -> void:
	gun_animation_player.play("Cube_001Action")
	gun_animation_player.pause()

	player_node.grab.connect(start_grab_animation)
	player_node.release.connect(stop_grab_animation)
	
func start_grab_animation(_object : Node3D) -> void:
	gun_animation_player.play()
	
func stop_grab_animation() -> void:
	gun_animation_player.pause()
