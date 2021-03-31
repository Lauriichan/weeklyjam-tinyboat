extends AudioStreamPlayer2D
class_name EffectPlayer

var play : bool = true;

func _ready():
	var storage : Storage = get_node("/root/Storage");
	var _ignore = storage.connect("value_updated", self, "update_volume");
	update_volume("sfx_volume", storage.get_value_or("sfx_volume", 20));
	
func play_effect():
	if play:
		play();
	
func update_volume(path, value):
	if path == "sfx_volume":
		if value == 0:
			stop();
			play = false;
			return;
		volume_db = -int((100 - (value * 5)) / 2);
