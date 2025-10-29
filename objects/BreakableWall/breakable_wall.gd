extends Node3D

var player: PlayerControl

func _ready() -> void:
	player.interact.connect(break_wall)

func break_wall(obj: Node3D):
	if obj == self:
		self.queue_free()