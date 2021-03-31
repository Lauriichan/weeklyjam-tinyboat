extends Label

export var signal_node : String;
export var signal_name : String;

export var value_path : String;
export var default_value : String;

func _ready():
	var node = get_node_or_null(signal_node);
	if node:
		node.connect(signal_name, self, "update_value");
	if value_path:
		text = str(get_node("/root/Storage").get_value_or(value_path, default_value));
		
func update_value(var value):
	text = str(value);
