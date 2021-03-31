extends Button

export var scene : String;
export var node_path : String;
export var focus : bool;

var path : String;
var node : Node;

func _ready():
	path = "res://scenes/" + scene + ".tscn";
	var _ignore = connect("pressed", self, "change");
	if node_path:
		node = get_node_or_null(node_path);
	if not node:
		node = self;
	_ignore = node.connect("visibility_changed", self, "visibility_updated");
	if focus:
		grab_focus();

func change():
	_before_change();
	var _ignore = get_tree().change_scene(path);

func visibility_updated():
	if focus and node.visible:
		grab_focus();
	
func _before_change():
	pass
