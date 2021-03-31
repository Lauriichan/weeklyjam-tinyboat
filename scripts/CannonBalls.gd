extends Node2D

func freeze():
	for node in get_children():
		node.freeze();
	
func unfreeze():
	for node in get_children():
		node.unfreeze();
