extends Node3D

@onready var area = $CollectionArea
func _ready() -> void:
	area.body_entered.connect(body_entered)

func body_entered(body: Node3D):
	if body is CharacterBody3D:
		# Collect
		self.queue_free()
