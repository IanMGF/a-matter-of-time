extends Node

@onready var player_node: PlayerControl = self.get_parent()

var is_holding = false
var grabbed_obj: Node3D = null
func _unhandled_input(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
	
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	
	if not event.is_pressed():
		return
	
	if not is_holding:
		player_node.attempt_grab()
	else:
		player_node.release.emit()
	
func add_outline(body: RigidBody3D):
	body.add_to_group("Grabbed")
	is_holding = true
	grabbed_obj = body
	body.get_node("Model/Cube/Outline").visible = true

func remove_outline():
	grabbed_obj.remove_from_group("Grabbed")
	is_holding = false
	grabbed_obj.get_node("Model/Cube/Outline").visible = false
	grabbed_obj = null

func _ready() -> void:
	player_node.grab.connect(add_outline)
	player_node.release.connect(remove_outline)
