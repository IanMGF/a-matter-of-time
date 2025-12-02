extends Node3D

@onready var room_o: CSGCombiner3D = $"../Room4O"
@onready var room_b_trigger: Area3D = $BRoomTrigger
@onready var stationary_area: Area3D = $StationaryArea

func _ready() -> void:
	room_b_trigger.body_entered.connect(trigger_b)

func trigger_b(body: Node3D) -> void:
	if (body is CharacterBody3D):
		var grabbed = room_o.get_tree().get_nodes_in_group("Grabbed")
		var room_o_pos = room_o.global_position
		for g in grabbed:
			if g.get_parent() == room_o:
				g.reparent(self)
		room_o.global_position = self.global_position
		for g in grabbed:	
			if g.get_parent() == self:
				g.reparent(room_o)

		self.global_position = room_o_pos
