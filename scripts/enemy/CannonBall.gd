extends RigidBody2D
class_name CannonBall

export var timeToLive : float = 0;
var template : bool = true;
var tick : int = 12;
	
func spawn():
	sleeping = false;
	template = false;

func _physics_process(delta):
	if not sleeping and not template:
		if tick != -1:
			tick -= 1;
			if tick == 0:
				collision_layer = 2;
				collision_mask = 2;
		timeToLive -= delta;
		if timeToLive <= 0:
			free();
