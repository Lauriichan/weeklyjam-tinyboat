extends Node
class_name MusicPlayer

var game_loops : Array = ["res://audio/music/loops/game/The_Wild-Game-1.wav","res://audio/music/loops/game/The_Wild-Game-2.wav","res://audio/music/loops/game/The_Wild-Game-3.wav","res://audio/music/loops/game/The_Wild-Game-4.wav","res://audio/music/loops/game/The_Wild-Game-5.wav","res://audio/music/loops/game/The_Wild-Game-6.wav","res://audio/music/loops/game/The_Wild-Game-7.wav","res://audio/music/loops/game/The_Wild-Game-8.wav","res://audio/music/loops/game/The_Wild-Game-9.wav","res://audio/music/loops/game/The_Wild-Game-10.wav","res://audio/music/loops/game/The_Wild-Game-11.wav","res://audio/music/loops/game/The_Wild-Game-12.wav"];
var menu_loops : Array = ["res://audio/music/loops/menu/The_Wild-Menu-1.wav","res://audio/music/loops/menu/The_Wild-Menu-2.wav","res://audio/music/loops/menu/The_Wild-Menu-3.wav","res://audio/music/loops/menu/The_Wild-Menu-4.wav","res://audio/music/loops/menu/The_Wild-Menu-5.wav","res://audio/music/loops/menu/The_Wild-Menu-6.wav"];
var transfers : Array = ["res://audio/music/transfer/The_Wild-Game2Menu.wav","res://audio/music/transfer/The_Wild-Menu2Game.wav","res://audio/music/transfer/The_Wild-Start2Menu.wav"];

var current : float = 0.0;

var transfer = 2; # -1 = Off / 0 = G -> M / 1 = M -> G / 2 = S -> M

var loop_type = 0; # 0 = Menu / 1 = Game
var loop_index = -1;

var requested_type = 0;

var menu_loop_amount = 0;
var game_loop_amount = 0;

var disabled : bool = false;
var volume : float = 0;

var stream : AudioStreamPlayer;

func _ready():
	var storage : Storage = get_node("/root/Storage");
	var _ignore = storage.connect("value_updated", self, "update_volume")
	load_resources(game_loops);
	game_loop_amount = game_loops.size();
	load_resources(menu_loops);
	menu_loop_amount = menu_loops.size();
	load_resources(transfers);
	update_volume("music_volume", storage.get_value_or("music_volume", 20.0));

func load_resources(var array):
	var _ignore;
	for i in range(array.size()):
		var sample = load(array[i]);
		var player = AudioStreamPlayer.new();
		add_child(player);
		player.bus = "Music"
		player.stream = sample;
		player.connect("finished", self, "continue_play");
		array[i] = player;
	
func update_volume(path, value):
	if path == "music_volume":
		if value == 0:
			current = get_current_playback();
			disabled = true;
			stop();
			return;
		elif not playing():
			if stream:
				play_at(current);
			else:
				play_music();
		volume = (-int((100 - (value * 5)) / 4)) - 16;
		if stream:
			stream.volume_db = volume;

func get_current_playback() -> float:
	if stream:
		return stream.get_playback_position();
	return 0.0;
	
func stop():
	if stream:
		stream.stop();
	
func play():
	play_at(0.0);
	
func play_at(var value):
	if stream:
		stream.volume_db = volume;
		stream.play(value);
	
func playing() -> bool:
	if stream:
		return stream.playing;
	return false;
		
func request(var type : int):
	requested_type = type;

func continue_play():
	if disabled:
		return;
	if transfer == -1:
		if loop_type == 0:
			if requested_type == 1:
				transfer = 1;
				loop_type = 1;
				loop_index = -1;
			else:
				loop_index += 1;
		elif loop_type == 1:
			if requested_type == 0:
				transfer = 0;
				loop_type = 0;
				loop_index = -1;
			else:
				loop_index += 1;
	play_music();
		
func play_music():
	if transfer != -1:
		stream = transfers[transfer];
		stream.play();
		if stream.volume_db != volume:
			stream.volume_db = volume;
		transfer = -1;
	elif loop_type == 0:
		if loop_index >= menu_loop_amount || loop_index == -1:
			loop_index = 0;
		stream = menu_loops[loop_index];
		stream.play();
		if stream.volume_db != volume:
			stream.volume_db = volume;
	elif loop_type == 1:
		if loop_index >= game_loop_amount || loop_index == -1:
			loop_index = 0;
		stream = game_loops[loop_index];
		stream.play();
		if stream.volume_db != volume:
			stream.volume_db = volume;
