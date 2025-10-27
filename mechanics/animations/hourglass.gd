extends Node3D

@onready var angle_y = 0;
@onready var angle_p = 0;
@onready var angle_r = 0;

@onready var angle_tween = create_tween()

func _ready() -> void:
	angle_tween.set_loops(-1)
	angle_tween.set_parallel(true)

	angle_tween.tween_property(self, "global_rotation:x", 2 * PI, 2.0) \
		.set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN_OUT)

	angle_tween.tween_property(self, "global_rotation:y", 2 * PI, 1.7) \
		.set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN_OUT)


	angle_tween.tween_property(self, "global_rotation:z", 2 * PI, 2.1) \
		.set_trans(Tween.TRANS_LINEAR) \
		.set_ease(Tween.EASE_IN_OUT)
