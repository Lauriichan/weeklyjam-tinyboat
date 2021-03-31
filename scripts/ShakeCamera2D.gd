extends Camera2D
class_name ShakeCamera2D

export var decay : float;
export var max_offset : Vector2;
export var max_roll : float;

export var shake_power : float;

var shake : float = 0;

var noise : OpenSimplexNoise;
var noise_y : int = 0;

func _ready():
	randomize();
	noise = OpenSimplexNoise.new();
	noise.seed = randi();
	noise.period = 5;
	noise.octaves = 1;
	
func trigger_shake():
	trigger_shake_with(0.1);
	
func trigger_shake_with(var amount : float):
	shake = min(shake + amount, 1.0);
	
func _process(delta):
	if shake:
		shake = max(shake - decay * delta, 0);
		shake_camera();
		
func shake_camera():
	var amount = pow(shake, shake_power);
	noise_y += 1;
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
