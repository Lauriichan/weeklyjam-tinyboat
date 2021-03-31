extends RigidBody2D
class_name LocalPlayer

export var components : Array;

var healthbar : TextureBar;
var settings : PlayerSettings;

var pause : PauseHandler;
var camera : ShakeCamera2D;
var score : ScoreStore;

var hit_player : EffectPlayer;

var freezed = false;

func _ready():
	score = get_node("/root/Score");
	pause = get_node("/root/Scene/Handlers/PauseHandler")
	hit_player = get_node("HitPlayer");
	camera = get_node("/root/Scene/Camera2D");
	settings = get_node("/root/Scene/Settings/Player")
	healthbar = get_node("/root/Scene/UI/Healthbar");
	for i in range(components.size()):
		components[i] = components[i].new();
		components[i].set_player(self);
		
func freeze():
	if not freezed:
		for component in components:
			if component.has_method("freeze"):
				component.freeze();
		freezed = true;
	
func unfreeze():
	if freezed:
		for component in components:
			if component.has_method("unfreeze"):
				component.unfreeze();
		freezed = false;

func can_take_damage() -> bool:
	return true;
	
func damage(var value : int):
	var health = int(healthbar.get_value()) - value;
	healthbar.set_value(health);
	camera.trigger_shake_with(0.5);
	if health <= 0:
		pause.freeze();

func _physics_process(var _delta : float):
	if components.size() == 0 or freezed:
		if healthbar.get_value() <= 0 and not hit_player.playing:
			hit_player.play_effect();
			yield(hit_player, "finished");
			var _ignore = score.save();
			_ignore = get_tree().change_scene("res://scenes/Menu.tscn");
		return;
	for component in components:
		component._update(_delta);
