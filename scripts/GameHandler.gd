extends Node2D

export var min_size : Vector2;
var window_size : Vector2;
var window_position : Vector2;

func ready():
	window_size = OS.get_window_size();
	window_position = OS.get_window_position();

func _physics_process(delta):
	if OS.get_window_size() != window_size:
		window_size = OS.get_window_size();
		if window_size.x < min_size.x || window_size.y < min_size.y:
			if window_size.x < min_size.x:
				window_size.x = min_size.x;
			if window_size.y < min_size.y:
				window_size.y = min_size.y;
			OS.set_window_size(window_size);
			OS.set_window_position(window_position);
	if OS.get_window_position() != window_position:
		window_position = OS.get_window_position();
