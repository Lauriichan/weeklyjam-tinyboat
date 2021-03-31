extends Node
class_name Storage

signal value_updated(path, value);

var file_path = "user://game.save"

var data : Dictionary = {};

func _ready():
	load_from_file();
	set_name("Storage");
	
func get_value(var path : String):
	return data[path];
	
func get_value_or(var path : String, var default):
	if path in data:
		return data[path];
	else:
		return default;

func has_value(var path : String) -> bool:
	return path in data;
	
func set_value(var path : String, var value):
	data[path] = value;
	save_to_file();
	emit_signal("value_updated", path, value);

func load_from_file():
	var file = File.new();
	if !file.file_exists(file_path):
		return;
	file.open(file_path, File.READ);
	data = parse_json(file.get_as_text());
	file.close();
	
func save_to_file():
	var file = File.new();
	file.open(file_path, File.WRITE);
	file.store_string(to_json(data));
	file.close();
