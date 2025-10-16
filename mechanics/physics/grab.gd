extends Node3D

@export var left_controller: XRController3D
@export var right_controller: XRController3D

var holding = false
var rel_pos = Vector3(0, 0, 0)

func _physics_process(delta: float) -> void:
	if left_controller.is_button_pressed("grip"):
		var area_3d: Area3D = left_controller.get_child(1)
		if area_3d.overlaps_body(self.get_child(2)) and !holding:
			print("Enable Holding")
			holding = true
			rel_pos = self.global_position - area_3d.global_position
		
		elif holding:
			print("Executing Holding")
			self.global_position = area_3d.global_position + self.rel_pos
	elif holding:
		print("Disabling Hold")
		holding = false
