extends KinematicBody2D
class_name LocalPlayer

export var components : Array;

var settings : Settings;

func _ready():
	settings = get_node("/root/Scene/Settings")
	for i in range(components.size()):
		components[i] = components[i].new();
		components[i].set_player(self);
	

func _physics_process(var _delta : float):
	if components.size() == 0:
		return;
	for component in components:
		component._update(_delta);
