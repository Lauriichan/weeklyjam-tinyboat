extends Button

export var exit : bool;

var pause : Control;
var popup : Control;

func _ready():
	pause = get_node("/root/Scene/Menu/PauseMenu");
	popup = get_node("/root/Scene/Menu/ExitPopup");
	
func _pressed():
	release_focus();
	if exit:
		pause.visible = false;
		popup.visible = true;
	else:
		pause.visible = true;
		popup.visible = false;
