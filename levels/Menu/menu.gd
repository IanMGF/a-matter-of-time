extends Node

@onready var start_button: Button = $Button

func _ready():
	start_button.pressed.connect(on_press)

func on_press():
	print("Changing")
	get_tree().change_scene_to_file("res://levels/level1.tscn")
