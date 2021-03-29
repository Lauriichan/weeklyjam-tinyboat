extends Node
class_name PlayerSettings

export var use_controller : bool = false;

export var rotation_speed : float;
export var move_speed : float;

export var fuel_usage : float;
export var fuel_regen : float;

func _ready():
	var storage : Storage = get_node("/root/Storage");
	if "controller" in storage.data:
		use_controller = storage.data["controller"];
