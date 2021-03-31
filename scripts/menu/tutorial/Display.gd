extends TextureRect

export var index : int = 0;
export var array : Array = ["res://concepts/tutorial/exported/tutorial-0.png","res://concepts/tutorial/exported/tutorial-1.png","res://concepts/tutorial/exported/tutorial-2.png","res://concepts/tutorial/exported/tutorial-3.png","res://concepts/tutorial/exported/tutorial-4.png","res://concepts/tutorial/exported/tutorial-5.png","res://concepts/tutorial/exported/tutorial-6.png","res://concepts/tutorial/exported/tutorial-7.png","res://concepts/tutorial/exported/tutorial-8.png","res://concepts/tutorial/exported/tutorial-9.png","res://concepts/tutorial/exported/tutorial-10.png","res://concepts/tutorial/exported/tutorial-11.png"]

var max_index : int = 0;

var next : Button;
var prev : Button;
var menu : Button;

func _ready():
	prev = get_node("/root/Scene/Previous");
	next = get_node("/root/Scene/Next");
	menu = get_node("/root/Scene/Menu");
	max_index = array.size();
	if max_index > 0:
		load_texture();
	if next.disabled:
		menu.grab_focus();
	else:
		next.grab_focus();
	
func next():
	if index + 1 == max_index:
		return;
	index += 1;
	load_texture();

func has_next() -> bool:
	return index + 1 != max_index;
	
func prev():
	if index == 0:
		return;
	index -= 1;
	load_texture();
	
func has_prev() -> bool:
	return index != 0;
	
func get_index() -> int:
	return index;
	
func get_max_index() -> int:
	return max_index;

func load_texture():
	texture = load(array[index]);
	update_next();
	update_prev();

func update_next():
	if has_next():
		next.disabled = false;
		next.focus_mode = 2;
	else:
		next.disabled = true;
		next.focus_mode = 0;
		menu.grab_focus();
	
func update_prev():
	if has_prev():
		prev.disabled = false;
		prev.focus_mode = 2;
	else:
		prev.disabled = true;
		prev.focus_mode = 0;
		menu.grab_focus();

func _on_Next_pressed():
	next();

func _on_Previous_pressed():
	prev();
