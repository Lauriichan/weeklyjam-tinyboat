extends Node
class_name Storage

var file_path = "user://game.save"

var data : Dictionary = {};

func _ready():
	load_from_file();
	set_name("Storage");

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
