tool
extends Node2D
class_name Cannon

const radian = PI / 180;

var cannonball : CannonBall;
var balls : Node2D;

var sprite : AnimatedSprite;

var player : LocalPlayer;
var boat : Boat;

export var shoot : bool = false;
export var active : bool = false;
export var max_speed : int = 50;
export var min_speed : int = 30;
export var sound : AudioStreamSample setget set_sample;
export var shoot_point : float = 0 setget set_shoot_point;
export var ball_speed : float = 10;

var audio_player : EffectPlayer;

var tick : int;

func set_shoot_point(var point):
	shoot_point = point;
	update();

func set_sample(var sample):
	sound = sample;
	if audio_player != null:
		audio_player.stream = sound;

func kill():
	boat = null;
	player = null;
	audio_player.queue_free();
	get_parent().remove_child(self);

func _ready():
	randomize();
	tick = new_tick();
	boat = get_parent();
	sprite = get_node("Sprite");
	audio_player = get_node("AudioPlayer");
	audio_player.stream = sound;
	player = get_node("/root/Scene/Player");
	cannonball = get_node("/root/Scene/Templates/CannonBall");
	balls = get_node("/root/Scene/CannonBalls");
	boat.add_cannon(self);

func new_tick() -> int:
	return int(round(rand_range(0, 1) * (max_speed - min_speed))) + min_speed;
	
func _draw():
	if !Engine.editor_hint:
		return;
	draw_circle(Vector2(0, shoot_point), 1, Color(0, 0, 0, 1));

func _physics_process(_delta):
	if Engine.editor_hint || !active:
		return;
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
			var location = get_cannon_position();
			ball.linear_velocity = Vector2(player.position.x - location.x, player.position.y - location.y).normalized();
			ball.linear_velocity.x *= ball_speed;
			ball.linear_velocity.y *= ball_speed;
			ball.position = location;
			ball.spawn();
			audio_player.play_effect();
	
func get_cannon_position() -> Vector2:
	var cannon = Math.point_on_circle_with(Math.radius_of_circle(position), -boat.rotation, atan2(position.x, position.y));
	cannon.x += boat.position.x;
	cannon.y += boat.position.y;
	return cannon;
	
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
