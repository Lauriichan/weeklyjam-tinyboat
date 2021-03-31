extends KinematicBody2D
class_name Boat

export var health : int = 1;
export var score : int;
export var sound : AudioStreamSample setget set_sample;

var type_id : int = -1;

var sprite : Sprite;

var player : LocalPlayer;
var settings : EnemySettings;
var score_store : ScoreStore;

var audio_player : EffectPlayer;

var layer : int = 0;

var cannons : Array;

var freezed = false;
var active = false;

func set_sample(var sample):
	sound = sample;
	if audio_player != null:
		audio_player.stream = sound;

func can_take_damage() -> bool:
	return true;
	
func damage(var value : int):
	health -= value;
	if health == 0:
		score_store.add_score(score);
		audio_player.play_effect();
		for cannon in cannons:
			cannon.active = false;
			cannon.visible = false;
		active = false;
		visible = false;
		yield(audio_player, "finished");
		queue_free();

func set_type_id(var id : int):
	type_id = id;
	
func get_type_id() -> int:
	return type_id;
	
func has_type_id() -> bool:
	return type_id != -1;
	
func _ready():
	sprite = get_node("Sprite");
	player = get_node("/root/Scene/Player");
	settings = get_node("/root/Scene/Settings/Enemy");
	score_store = get_node("/root/Score");
	audio_player = get_node("AudioPlayer");
	audio_player.stream = sound;
	layer = collision_layer;
	collision_layer = 0;
	collision_mask = 0;
	
func add_cannon(cannon):
	if cannons.has(cannon):
		return;
	cannons.append(cannon);
	
func spawn():
	collision_layer = layer;
	collision_mask = layer;
	active = true;
	for cannon in cannons:
		cannon.active = true;
		cannon.shoot = true;
		
func freeze():
	if active and not freezed:
		for cannon in cannons:
			cannon.active = false;
		freezed = true;
	
func unfreeze():
	if active and freezed:
		for cannon in cannons:
			cannon.active = true;
		freezed = false;

func _physics_process(_delta):
	if active and not freezed:
		rotation = player.rotation;
