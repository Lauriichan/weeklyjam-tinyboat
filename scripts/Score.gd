extends Node
class_name ScoreStore

signal score_updated(value);
signal highscore_updated(value);

var storage : Storage;
var highscore : int;

var current_score = 0;
var queue : Array = [];

func _ready():
	storage = get_node("/root/Storage");
	highscore = storage.get_value_or("highscore", 0);

func get_highscore() -> int:
	return highscore;
	
func add_score(var value : int):
	queue.append(value);
	
func save() -> bool:
	update_score();
	if current_score > highscore:
		highscore = current_score;
		storage.set_value("highscore", highscore);
		emit_signal("highscore_updated", highscore);
		current_score = 0;
		return true;
	current_score = 0;
	return false;
	
func _physics_process(_delta):
	update_score();

func update_score():
	if queue.empty():
		return;
	var size = queue.size();
	for _index in range(size):
		current_score += queue[0];
		queue.remove(0);
	emit_signal("score_updated", current_score);
