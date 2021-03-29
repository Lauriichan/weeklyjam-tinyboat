extends Button

export var main_menu : bool;
export var select_control : String;

var main : MarginContainer;
var options : MarginContainer;

var select : Control;

func _ready():
	var _ignore = connect("pressed", self, "change");
	main = get_node("/root/Scene/Main");
	options = get_node("/root/Scene/Options");
	if select_control:
		if main_menu:
			select = main.get_node(select_control);
		else:
			select = options.get_node(select_control);

func change():
	if main_menu:
		if main.visible:
			return;
		options.hide();
		main.show();
		if select:
			select.grab_focus();
	else:
		if options.visible:
			return;
		main.hide();
		options.show();
		if select:
			select.grab_focus();
