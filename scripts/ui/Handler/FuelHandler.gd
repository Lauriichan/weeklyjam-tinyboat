tool
extends Node
class_name FuelHandler

export var critical_block_texture : Texture;
var block_texture : Texture;
var fuelbar : TextureBar;

func _ready():
	fuelbar = get_node("/root/Scene/Control/Fuelbar");
	fuelbar.connect("value_changed", self, "fuel_changed");
	block_texture = fuelbar.block_texture;
	
func fuel_changed(var value : float):
	if value >= 20.0:
		fuelbar.set_block_texture(critical_block_texture);
	else:
		fuelbar.set_block_texture(block_texture);
