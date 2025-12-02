extends Node3D

var has_hourglass: bool = false

func _ready() -> void:
	var body: CharacterBody3D = $"../CharacterBody3D"
