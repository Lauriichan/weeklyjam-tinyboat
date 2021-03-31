tool
extends TextureBar
class_name TextureSlider

export var slider_texture : Texture setget set_slider_texture;
export var slider_texture_highlight : Texture setget set_slider_texture_highlight;
export var slider_size : float = 1 setget set_slider_size;
export var slider_offset_x : float = 0 setget set_slider_offset_x;
export var slider_offset_y : float = 0 setget set_slider_offset_y;
export var _focus_mode : int setget set_focus_mode;
export var storage_path : String;

onready var storage : Storage = get_node("/root/Storage");

var slider_ratio : float = 1;
var highlight : bool = false;
var focused : bool = false;
var tick : int = 4;

func set_focus_mode(var _focus : int):
	focus_mode = _focus;
	_focus_mode = _focus;
	update();

func set_slider_offset_x(var _offset : float):
	slider_offset_x = _offset;
	update();

func set_slider_offset_y(var _offset : float):
	slider_offset_y = _offset;
	update();

func set_slider_size(var _size : float):
	if _size <= 0:
		slider_size = 0.001;
	else:
		slider_size = _size;
	update();

func set_slider_texture(var texture : Texture):
	slider_texture = texture;
	if texture != null:
		var tmp = slider_texture.get_size();
		slider_ratio = tmp.y / tmp.x;
	update();
	
func set_slider_texture_highlight(var texture : Texture):
	slider_texture_highlight = texture;
	update();
	
func _ready():
	if storage_path and storage.has_value(storage_path):
		set_value(max_value - storage.get_value(storage_path));
	
func _draw():
	if slider_texture != null:
		if vertical_row:
			draw_slider_y();
		else:
			draw_slider_x();
		
func draw_slider_y():
	var difference = int(max_value - round(value));
	var offset_y = block_offset_y;
	var offset_x = block_offset_x + bar_offset;
	var expand_y = block_size.y * block_stretch + block_row_offset;
	var block_offset = block_size.y * block_stretch;
	offset_y += expand_y * difference + block_offset * difference;
	var _slider_size = slider_texture.get_size();
	_slider_size = Vector2(block_row_offset * slider_size, block_row_offset * slider_ratio * slider_size);
	var texture : Texture = slider_texture;
	if highlight && slider_texture_highlight != null:
		texture = slider_texture_highlight;
	texture.draw_rect(self.get_canvas_item(), Rect2(Vector2(offset_x + slider_offset_x, offset_y + slider_offset_y), _slider_size), false);
	

func draw_slider_x():
	var difference = int(max_value - round(value));
	var offset_y = block_offset_y + bar_offset;
	var offset_x = block_offset_x;
	var expand_x = block_size.x * block_stretch + block_row_offset;
	offset_x += (expand_x * difference) - block_row_offset - (block_row_offset / 2);
	var _slider_size = slider_texture.get_size();
	_slider_size = Vector2(block_row_offset * slider_size, block_row_offset * slider_ratio * slider_size);
	var texture : Texture = slider_texture;
	if highlight && slider_texture_highlight != null:
		texture = slider_texture_highlight;
	texture.draw_rect(self.get_canvas_item(), Rect2(Vector2(offset_x + slider_offset_x, offset_y + slider_offset_y), _slider_size), false);

func _physics_process(_delta):
	if not focused:
		return;
	var data = Input.get_joy_axis(0, 0);
	if data > 0.5 || data < -0.5:
		if tick != 0:
			tick -= 1;
		else:
			tick = 3;
			if data > 0:
				update_value(value - 1);
			else:
				update_value(value + 1);

func _gui_input(event):
	if Input.is_action_pressed("mouse_click"):
		update_value(get_value_at(get_local_mouse_position()));
	elif event.is_action_pressed("ui_left"):
		update_value(value + 1);
	elif event.is_action_pressed("ui_right"):
		update_value(value - 1);

func get_value_at(var position : Vector2) -> float:
	if vertical_row:
		return get_value_at_v(position);
	return get_value_at_h(position);
	
func get_value_at_v(var position : Vector2) -> float:
	if position.y < block_offset_y:
		return max_value;
	elif position.y > (rect_size.y - block_offset_y):
		return 0.0;
	var offset_y = block_offset_y;
	var expand_y = block_size.y * block_stretch + block_row_offset;
	var _max = int(max_value);
	var distance = expand_y;
	var nearest = value;
	for _value in range(_max + 1):
		var tmp = abs(position.y - offset_y);
		if tmp < distance:
			distance = tmp;
			nearest = _value;
		offset_y += expand_y;
	return _max - nearest;
	
func get_value_at_h(var position : Vector2) -> float:
	if position.x < block_offset_x:
		return max_value;
	elif position.x > (rect_size.x - block_offset_x):
		return 0.0;
	var offset_x = block_offset_x;
	var expand_x = block_size.x * block_stretch + block_row_offset;
	var _max = int(max_value);
	var distance = expand_x;
	var nearest = value;
	for _value in range(_max + 1):
		var tmp = abs(position.x - offset_x);
		if tmp < distance:
			distance = tmp;
			nearest = _value;
		offset_x += expand_x;
	return _max - nearest;

func update_value(var value):
	set_value(value);
	if storage_path:
		storage.set_value(storage_path, get_actual_value());

func _notification(what):
	match what:
		NOTIFICATION_MOUSE_ENTER:
			highlight = true;
			update();
		NOTIFICATION_MOUSE_EXIT:
			highlight = false;
			update();
		NOTIFICATION_FOCUS_ENTER:
			highlight = true;
			focused = true;
			tick = 4;
		NOTIFICATION_FOCUS_EXIT:
			highlight = false;
			focused = false;
	
