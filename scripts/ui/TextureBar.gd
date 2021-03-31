tool
extends Control
class_name TextureBar

signal value_changed(value);

export var bar_texture : Texture setget set_texture;
export var block_texture : Texture setget set_block_texture;
export var start_block_texture : Texture setget set_start_texture;
export var end_block_texture : Texture setget set_end_texture;
export var offset_block_texture : Texture setget set_offset_texture;

export var value : float setget set_value;
export var max_value : float setget set_max_value;

export var block_stretch : float = 1 setget set_stretch;
export var block_offset_x : float = 1 setget set_offset_x;
export var block_offset_y : float = 1 setget set_offset_y;
export var block_row_offset : float = 0 setget set_row_offset;
export var vertical_row : bool = false setget set_vertical;
export var max_on_start : bool = true;

export var bar_offset : float = 0 setget set_bar_offset;
export var min_size : Vector2 setget set_min_size;

export var opacity : float = 100 setget set_opacity;

var ratio : float = 1;
var offset_ratio : float = 1;

var block_size : Vector2;
var alpha : float = 0;

func set_min_size(var _size : Vector2):
	min_size = _size;

func set_bar_offset(var _offset : float):
	if _offset < 0:
		bar_offset = 0;
	else:
		bar_offset = _offset;
	update();

func set_opacity(var _opacity : float):
	if _opacity > 100:
		opacity = 100;
	elif _opacity < 0:
		opacity = 0;
	else:
		opacity = _opacity;
	alpha = opacity / 100;
	update();

func set_vertical(var vertical : bool):
	vertical_row = vertical;
	if offset_block_texture != null:
		var tmp = offset_block_texture.get_size();
		if vertical:
			offset_ratio = tmp.x / tmp.y;
		else:
			offset_ratio = tmp.y / tmp.x;
	update();

func set_row_offset(var offset : float):
	if offset < 0:
		block_row_offset = 0;
	else:
		block_row_offset = offset;
	update();

func set_offset_x(var offset : float):
	if offset < 0:
		block_offset_x = 0;
	else:
		block_offset_x = offset;
	update();

func set_offset_y(var offset : float):
	if offset < 0:
		block_offset_y = 0;
	else:
		block_offset_y = offset;
	update();

func set_stretch(var stretch : float):
	if stretch <= 0:
		block_stretch = 1;
	else:
		block_stretch = stretch;
	update();

func set_offset_texture(var texture : Texture):
	offset_block_texture = texture;
	if texture != null:
		var tmp = offset_block_texture.get_size();
		offset_ratio = tmp.y / tmp.x;
	update();

func set_end_texture(var texture : Texture):
	end_block_texture = texture;
	update();

func set_start_texture(var texture : Texture):
	start_block_texture = texture;
	update();

func set_block_texture(var texture : Texture):
	block_texture = texture;
	if texture != null:
		block_size = texture.get_size();
	update();

func set_texture(var texture : Texture):
	bar_texture = texture;
	var size : Vector2 = Vector2(0, 0);
	if texture != null:
		var tmp = bar_texture.get_size();
		size = Vector2(tmp.x / 10, 0);
		ratio = tmp.y / tmp.x;
	set_custom_minimum_size(size);
	update();
	
func set_value(var input : float):
	var prev = value;
	if input > max_value:
		value = max_value;
	elif input < 0:
		value = 0;
	else:
		value = input;
	if value != prev:
		emit_signal("value_changed", value);
	update();
	
func set_max_value(var input : float):
	if input < 0:
		max_value = 0;
	else:
		max_value = input;
	set_value(value);

func _ready():
	var _skip;
	_skip = connect("resized", self, "resize");
	if max_on_start:
		value = max_value;
	alpha = opacity / 100;
	
func _draw():
	if bar_texture != null:
		if vertical_row:
			bar_texture.draw_rect(self.get_canvas_item(), Rect2(Vector2(bar_offset, 0), Vector2(rect_size.x, rect_size.x * ratio)), false);
			if max_value > value:
				draw_row_y();
		else:
			bar_texture.draw_rect(self.get_canvas_item(), Rect2(Vector2(0, bar_offset), Vector2(rect_size.x, rect_size.x * ratio)), false);
			if max_value > value:
				draw_row_x();

func draw_row_y():
	var difference = int(max_value - round(value));
	var offset_y = block_offset_y;
	var offset_x = block_offset_x + bar_offset;
	var expand_y;
	var _offset_size;
	if offset_block_texture == null:
		expand_y = block_size.y * block_stretch + block_row_offset;
	else:
		_offset_size = Vector2(block_row_offset * offset_ratio, block_row_offset);
		expand_y = block_size.y * block_stretch;
	var current_size = Vector2(block_size.x * block_stretch, block_size.y * block_stretch);
	var modulation = Color(1, 1, 1, alpha);
	var max_draw = int(max_value) - 1;
	for i in range(difference):
		if i == 0 && start_block_texture != null:
			start_block_texture.draw_rect(self.get_canvas_item(), Rect2(Vector2(offset_x, offset_y), current_size), false);
		else:
			if i == max_draw && end_block_texture != null:
				end_block_texture.draw_rect(self.get_canvas_item(), Rect2(Vector2(offset_x, offset_y), current_size), false, modulation);
			elif block_texture != null:
				block_texture.draw_rect(self.get_canvas_item(), Rect2(Vector2(offset_x, offset_y), current_size), false, modulation);
		offset_y += expand_y;
		if i != max_draw && offset_block_texture != null:
			offset_block_texture.draw_rect(self.get_canvas_item(), Rect2(Vector2(offset_x, offset_y), _offset_size), false, modulation);
			expand_y += block_row_offset;

func draw_row_x():
	var difference = int(max_value - round(value));
	var offset_y = block_offset_y + bar_offset;
	var offset_x = block_offset_x;
	var expand_x;
	var _offset_size;
	if offset_block_texture == null:
		expand_x = block_size.x * block_stretch + block_row_offset;
	else:
		_offset_size = Vector2(block_row_offset, block_row_offset * offset_ratio);
		expand_x = block_size.x * block_stretch;
	var current_size = Vector2(block_size.x * block_stretch, block_size.y * block_stretch);
	var modulation = Color(1, 1, 1, alpha);
	var max_draw = int(max_value) - 1;
	for i in range(difference):
		if i == 0 && start_block_texture != null:
			start_block_texture.draw_rect(self.get_canvas_item(), Rect2(Vector2(offset_x, offset_y), current_size), false, modulation);
		else:
			if i == max_draw && end_block_texture != null:
				end_block_texture.draw_rect(self.get_canvas_item(), Rect2(Vector2(offset_x, offset_y), current_size), false, modulation);
			elif block_texture != null:
				block_texture.draw_rect(self.get_canvas_item(), Rect2(Vector2(offset_x, offset_y), current_size), false, modulation);
		offset_x += expand_x;
		if i != max_draw && offset_block_texture != null:
			offset_block_texture.draw_rect(self.get_canvas_item(), Rect2(Vector2(offset_x, offset_y), _offset_size), false, modulation);
			offset_x += block_row_offset;

func resize():
	set_size(Vector2(rect_size.x, rect_size.x * ratio));
	rect_min_size = min_size;
	
func get_value() -> float:
	return value;
	
func get_max_value() -> float:
	return max_value;
	
func get_actual_value() -> float:
	return max_value - value;
	
func get_actual_full_value() -> int:
	return int(get_actual_value());
	
func set_actual_value(var _value : float):
	set_value(max_value - _value);

func set_actual_full_value(var _value : int):
	set_actual_value(float(_value));
