extends RigidBody2D
class_name CannonBall

export var timeToLive : float = 0;
export var tick : int = 16;
export var explosion : AudioStreamSample;

var template : bool = true;

var audio_player : EffectPlayer;
var score : ScoreStore;

var velocity;
var freezed = false;

func set_sample(var sample):
	explosion = sample;
	if audio_player != null:
		audio_player.stream = explosion;
		
func _ready():
	score = get_node("/root/Score");
	audio_player = get_node("AudioPlayer");
	audio_player.stream = explosion;
	
func spawn():
	sleeping = false;
	template = false;

func freeze():
	if not freezed:
		velocity = linear_velocity;
		linear_velocity = Vector2(0, 0);
		freezed = true;
	
func unfreeze():
	if freezed:
		linear_velocity = velocity;
		freezed = false;

func _physics_process(delta):
	if not audio_player.playing and not sleeping and not template and not freezed:
		if tick != -1:
			tick -= 1;
			if tick == 0:
				collision_layer = 2;
				collision_mask = 2;
		timeToLive -= delta;
		var free = false;
		if collide():
			free = true;
			linear_velocity = Vector2(0, 0);
			visible = false;
			audio_player.play_effect();
			yield(audio_player, "finished");
		elif timeToLive <= 0:
			free = true;
			score.add_score(1);
		if free:
			queue_free();

func can_take_damage() -> bool:
	return false;

func collide() -> bool:
	var colliding = get_colliding_bodies();
	if colliding.size() == 0:
		return false;
	for entity in colliding:
		if entity is Shield:
			score.add_score(3);
			return false;
		if entity.can_take_damage():
			if not entity is LocalPlayer:
				score.add_score(5);
			entity.damage(1);
			return true;
	return false;
