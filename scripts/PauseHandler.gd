extends Node
class_name PauseHandler

var nodes : Array;
var pause : Control;
var popup : Control;

func _ready():
	pause = get_node("/root/Scene/Menu/PauseMenu");
	popup = get_node("/root/Scene/Menu/ExitPopup");
	for node in get_node("/root/Scene").get_children():
		if node.has_method("freeze") && node.has_method("unfreeze"):
			nodes.append(node);

func freeze():
	for node in nodes:
		node.freeze();

func unfreeze():
	for node in nodes:
		node.unfreeze();
		
func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_home"):
		if not pause.visible and popup.visible:
			pause.visible = true;
			popup.visible = false;
		elif not pause.visible and not popup.visible:
			pause.visible = true;
			freeze();
		elif pause.visible and not popup.visible:
			pause.visible = false;
			unfreeze();
