extends Button

var pause : Control;
var pause_handler : PauseHandler;

var get_focus = false;

func _ready():
	pause = get_node("/root/Scene/Menu/PauseMenu");
	pause_handler = get_node("/root/Scene/Handlers/PauseHandler")
	var _ignore = pause.connect("visibility_changed", self, "visibility_updated");
	
func _pressed():
	pause.visible = false;
	pause_handler.unfreeze();
	
func visibility_updated():
	if pause.visible:
		grab_focus();
		
