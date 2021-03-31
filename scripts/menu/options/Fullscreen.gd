extends Button

onready var storage : Storage = get_node("/root/Storage");

func _ready():
	var _ignore = connect("pressed", self, "change");
	update();

func change():
	storage.set_value("fullscreen", !storage.get_value_or("fullscreen", false));
	update();

func update():
	if storage.get_value_or("fullscreen", false):
		text = "ON";
		OS.window_fullscreen = true;
	else:
		text = "OFF";
		OS.window_fullscreen = false;
