extends Button

onready var storage : Storage = get_node("/root/Storage");
var controller : bool = false;

func _ready():
	var _ignore = connect("pressed", self, "change");
	if "fullscreen" in storage.data:
		update();

func change():
	if "fullscreen" in storage.data:
		storage.data["fullscreen"] = !storage.data["fullscreen"];
	else:
		storage.data["fullscreen"] = true;
	storage.save_to_file();
	update();

func update():
	if storage.data["fullscreen"]:
		text = "ON";
		OS.window_fullscreen = true;
	else:
		text = "OFF";
		OS.window_fullscreen = false;
