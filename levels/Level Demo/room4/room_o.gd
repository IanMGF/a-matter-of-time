extends Node3D

@onready var room_a: CSGCombiner3D = $"../Room4A"
@onready var room_b: CSGCombiner3D = $"../Room4B"

@onready var room_a_trigger: Area3D = $ARoomTrigger
@onready var room_b_trigger: Area3D = $BRoomTrigger

func _ready() -> void:
	room_a_trigger.body_entered.connect(trigger_a)
	room_b_trigger.body_entered.connect(trigger_b)

func trigger_a(body: Node3D) -> void:
	if (body is CharacterBody3D):
		var grabbed = room_a.get_tree().get_nodes_in_group("Grabbed")
		var room_a_pos = room_a.global_position
		for g in grabbed:
			if g.get_parent() == room_a:
				g.reparent(self)
		room_a.global_position = self.global_position
		for g in grabbed:
			if g.get_parent() == self:
				g.reparent(room_a)
		self.global_position = room_a_pos
		

func trigger_b(body: Node3D) -> void:
	if (body is CharacterBody3D):
		var grabbed = room_b.get_tree().get_nodes_in_group("Grabbed")
		var room_b_pos = room_b.global_position
		for g in grabbed:
			if g.get_parent() == room_b:
				g.reparent(self)
		room_b.global_position = self.global_position
		for g in grabbed:
			if g.get_parent() == self:
				g.reparent(room_b)
		self.global_position = room_b_pos
		
