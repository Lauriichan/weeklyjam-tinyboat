extends Node2D
class_name Cannon

onready var cannonball : CannonBall;
onready var balls : Node2D;

var sprite : AnimatedSprite;

var player : LocalPlayer;
var boat : Boat;

export var shoot : bool = false;
export var max_speed : int = 50;
export var min_speed : int = 30;

var tick : int;

func _ready():
	tick = new_tick();
	boat = get_parent();
	sprite = get_node("Sprite");
	player = get_node("/root/Scene/Player");
	cannonball = get_node("/root/Scene/Templates/CannonBall");
	balls = get_node("/root/Scene/CannonBalls");

func new_tick() -> int:
	return int(round(rand_range(0, 1) * (max_speed - min_speed))) + min_speed;

func _physics_process(_delta):
	update_rotation_for(atan2(player.position.x - (boat.position.x - position.x), player.position.y - (boat.position.y - position.y)));
	if shoot:
		if not tick == 0:
			tick -= 1;
		else:
			tick = new_tick();
			var ball : RigidBody2D = cannonball.duplicate();
			var tmp = ball.get_parent();
			if tmp:
				tmp.remove_child(ball);
			balls.add_child(ball);
			var x = player.position.x - (boat.position.x - position.x);
			var y = player.position.y - (boat.position.y - position.y);
			ball.linear_velocity.x = x;
			ball.linear_velocity.y = y;
			ball.position.x = boat.position.x - position.x;
			ball.position.y = boat.position.y - position.y;
			ball.spawn();
	
	
func update_rotation_for(var rotation : float):
	if rotation < 0:
		rotation = abs(rotation);
	else:
		rotation = 2 * PI - rotation;
	rotation = ((rotation * 180) / PI);
	rotation -= boat.rotation_degrees;
	var cannon_rotation = rotation_degrees + 180;
	if cannon_rotation > 360:
		cannon_rotation = cannon_rotation - 360;
		rotation_degrees = cannon_rotation - 180;
	elif cannon_rotation < 0:
		cannon_rotation = 360 + cannon_rotation;
		rotation_degrees = cannon_rotation - 180;
	if cannon_rotation != rotation:
		var amount = cannon_rotation - rotation;
		if amount > -1.2 && amount < 1.2:
			return;
		var angle = 360 - abs(amount);
		if angle < abs(amount):
			if amount > 0:
				angle = -angle;
			amount = angle;
		var rotate = amount;
		if abs(rotate) > boat.settings.cannon_rotate_speed:
			rotate = boat.settings.cannon_rotate_speed;
			if amount > 0:
				rotate = -rotate;
		rotation_degrees = rotate + rotation_degrees;
