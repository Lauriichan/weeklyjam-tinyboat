extends Button

onready var storage : Storage = get_node("/root/Storage");

func _ready():
	var _ignore = connect("pressed", self, "change");
	update();

func change():
	storage.set_value("controller", !storage.get_value_or("controller", false));
	update();

func update():
	if storage.get_value_or("controller", false):
		text = "ON";
	else:
		text = "OFF";
