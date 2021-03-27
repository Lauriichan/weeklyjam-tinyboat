tool
extends TileMap
class_name WaterHandler

export var scroll_speed : int = 2 setget set_scroll_speed;

var player : LocalPlayer;

func set_scroll_speed(var speed : int):
	speed = abs(speed);
	if speed % 2 != 0:
		speed = speed + 1;
	scroll_speed = speed;
	update();

func _ready():
	player = get_node("/root/Scene/Player");
	
func _physics_process(_delta):
	var rotate = player.rotation_degrees / 180
	var rotate_y = (abs(player.rotation_degrees) - 90) / 90;
	var rotate_x = 1 - abs(rotate_y)
	if rotate < 0:
		transform.origin.x += scroll_speed * rotate_x;
	else:
		transform.origin.x -= scroll_speed * rotate_x;
	transform.origin.y -= scroll_speed * rotate_y;
	if transform.origin.y >= 64 || transform.origin.y <= -64:
		transform.origin.y = 0;
	if transform.origin.x >= 64 || transform.origin.x <= -64:
		transform.origin.x = 0;
