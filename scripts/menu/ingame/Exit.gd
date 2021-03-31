extends "res://scripts/menu/ChangeScene.gd"

var score : ScoreStore;

func _ready():
	score = get_node("/root/Score");

func _before_change():
	var _ignore = score.save();
