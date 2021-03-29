extends Button

export var scene : String;
export var focus : bool;

var path : String;

func _ready():
	path = "res://scenes/" + scene + ".tscn";
	var _ignore = connect("pressed", self, "change");
	if focus:
		grab_focus();

func change():
	var _ignore = get_tree().change_scene(path);
