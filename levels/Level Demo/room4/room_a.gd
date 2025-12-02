extends Node3D

@onready var room_o: CSGCombiner3D = $"../Room4O"
@onready var room_a_trigger: Area3D = $ARoomTrigger

func _ready() -> void:
	room_a_trigger.body_entered.connect(trigger_a)

func trigger_a(body: Node3D) -> void:
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
		
