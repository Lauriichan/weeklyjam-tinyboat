tool
extends Node2D
class_name SpawnLocation

export var radius : float = 2 setget set_radius;
export var speed : float = 0.3;

var entity : Boat;
var location : Vector2;

var freezed : bool = false;

func set_radius(var _radius : float):
	radius = _radius;
	update();
	
func _draw():
	if !Engine.editor_hint:
		return;
	draw_circle(Vector2(0, 0), radius, Color(1, 0, 0, 0.6));
	
func _ready():
	randomize();
	
func freeze():
	freezed = true;
	
func unfreeze():
	freezed = false;

func has_entity() -> bool:
	return entity != null;

func clear_entity():
	entity = null;

func set_entity(var _entity : Boat):
	entity = _entity;
	if position.x > 0:
		entity.position.x = entity.position.x * -1;
	generate_location();
	entity.set_spawn_location(self);
	entity.spawn();
	entity.collision_layer = 2;
	entity.collision_mask = 2;
	
func generate_location():
	location = Math.point_on_circle(rand_range(0, radius), rand_range(-2, 2));
	location.x += position.x;
	location.y += position.y;
	
func _physics_process(_delta):
	if not entity or freezed:
		return;
	if entity.position.x != location.x or entity.position.y != location.y:
		var x = move_toward(entity.position.x, location.x, _delta * speed)
		var y = move_toward(entity.position.y, location.y, _delta * speed);
		entity.position = Vector2(x, y);
