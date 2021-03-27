extends Node2D

export var min_size : Vector2;
var window_size : Vector2;
var window_position : Vector2;

func ready():
	window_size = OS.get_window_size();
	window_position = OS.get_window_position();

func _process(delta):
	if OS.get_window_size() != window_size:
		window_size = OS.get_window_size();
		if window_size < min_size:
			window_size = min_size;
			OS.set_window_size(window_size);
			OS.set_window_position(window_position);
	if OS.get_window_position() != window_position:
		window_position = OS.get_window_position();
