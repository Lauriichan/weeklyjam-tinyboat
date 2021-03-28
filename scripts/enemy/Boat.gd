extends KinematicBody2D
class_name Boat

var sprite : Sprite;

var player : LocalPlayer;
var settings : EnemySettings;

func _ready():
	sprite = get_node("Sprite");
	player = get_node("/root/Scene/Player");
	settings = get_node("/root/Scene/Settings/Enemy");

func _physics_process(_delta):
	rotation_degrees = player.rotation_degrees;
