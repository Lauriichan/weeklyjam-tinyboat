extends Button

func _ready():
	var _ignore = connect("pressed", self, "change");

func change():
	get_tree().quit();
