class_name Movement

var player : KinematicBody2D;
var speed_level : int = 2;
var max_level : int = 3;

func set_player(var _player : KinematicBody2D):
	self.player = _player;
	
func _update(var _delta : float):
	update_position();
	update_rotation();
	update_speed_level();
	
func update_speed_level():
	if Input.is_action_just_pressed("game_level_up"):
		if speed_level != max_level:
			speed_level += 1;
	if Input.is_action_just_pressed("game_level_down"):
		if speed_level != 1:
			speed_level -= 1;

func update_position():
	var velocity = 0;
	if Input.is_action_pressed("game_forward"):
		velocity -= player.settings.move_speed * (1 + (speed_level - 2) * 0.25);
	if Input.is_action_pressed("game_backward"):
		if(velocity < 0):
			return;
		velocity += player.settings.move_speed * (0.75 + (speed_level - 2) * 0.25);
	if player.transform.origin.y >= 460 && velocity > 0 || player.transform.origin.y <= -460 && velocity < 0:
		return;
	player.transform.origin.y += velocity;

func update_rotation():
	if player.settings.use_controller:
		update_rotation_controller();
	else:
		update_rotation_mouse();

func update_rotation_controller():
	var x = 0;
	var y = 0;
	if Input.is_action_pressed("game_rotate_x+"):
		x += Input.get_action_strength("game_rotate_x+");
	if Input.is_action_pressed("game_rotate_y+"):
		y -= Input.get_action_strength("game_rotate_y+");
	if Input.is_action_pressed("game_rotate_x-"):
		x -= Input.get_action_strength("game_rotate_x-");
	if Input.is_action_pressed("game_rotate_y-"):
		y += Input.get_action_strength("game_rotate_y-");
	if x != 0 || y != 0:
		update_rotation_for(atan2(x, y));
	
func update_rotation_mouse():
	var position = player.get_global_mouse_position();
	update_rotation_for(atan2(position.x, position.y - player.transform.origin.y));

func update_rotation_for(var rotation : float):
	if rotation < 0:
		rotation = abs(rotation);
	else:
		rotation = 2 * PI - rotation;
	rotation = ((rotation * 180) / PI);
	var player_rotation = player.rotation_degrees + 180;
	if player_rotation > 360:
		player_rotation = player_rotation - 360;
		player.rotation_degrees = player_rotation - 180;
	elif player_rotation < 0:
		player_rotation = 360 + player_rotation;
		player.rotation_degrees = player_rotation - 180;
	if player_rotation != rotation:
		var amount = player_rotation - rotation;
		if amount > -1.2 && amount < 1.2:
			return;
		var angle = 360 - abs(amount);
		if angle < abs(amount):
			if amount > 0:
				angle = -angle;
			amount = angle;
		var rotate = amount;
		if abs(rotate) > player.settings.rotation_speed:
			rotate = player.settings.rotation_speed;
			if amount > 0:
				rotate = -rotate;
		player.rotation_degrees = rotate + player.rotation_degrees;
