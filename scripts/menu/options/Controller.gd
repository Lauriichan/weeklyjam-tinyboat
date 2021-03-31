extends Button

onready var storage : Storage = get_node("/root/Storage");

func _ready():
	var _ignore = connect("pressed", self, "change");
	update_text();

func change():
	storage.set_value("controller", !storage.get_value_or("controller", false));
	update_text();

func update_text():
	if storage.get_value_or("controller", false):
		text = "ON";
	else:
		text = "OFF";
