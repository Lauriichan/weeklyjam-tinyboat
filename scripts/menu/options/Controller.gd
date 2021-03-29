extends Button

onready var storage : Storage = get_node("/root/Storage");
var controller : bool = false;

func _ready():
	var _ignore = connect("pressed", self, "change");
	if "controller" in storage.data:
		update();

func change():
	if "controller" in storage.data:
		storage.data["controller"] = !storage.data["controller"];
	else:
		storage.data["controller"] = true;
	storage.save_to_file();
	update();

func update():
	if storage.data["controller"]:
		text = "ON";
	else:
		text = "OFF";
