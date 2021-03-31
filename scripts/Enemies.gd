extends Node2D

export var enemies : Array;
export var max_amount : Array;

export var spawn_speed : int = 1;
export var start_tick : float = 2;
export var spawn_tick : float = 5;

var enemy_nodes : Array;
var enemy_amount : Array;
var tick : float;

var freezed : bool = false;

var random : RandomNumberGenerator;

func _ready():
	random = RandomNumberGenerator.new();
	random.randomize();
	tick = start_tick;
	for enemy in enemies:
		var node = get_node_or_null(enemy);
		if node:
			node.set_type_id(enemy_nodes.size());
			enemy_nodes.append(node);
			enemy_amount.append(max_amount[enemies.find(enemy)]);

func _physics_process(_delta):
	if freezed:
		return;
	tick -= (_delta * (spawn_speed / 10.0));
	if not tick <= 0:
		return;
	tick = spawn_tick;
	var enemy = random.randi_range(0, enemy_nodes.size() - 1);
	var count = 0;
	var spawn;
	for child in get_children():
		if child.has_method("set_entity"):
			if child.has_entity() or spawn:
				continue;
			spawn = child;
			continue;
		if child.get_type_id() == enemy:
			count += 1;
	if max_amount[enemy] == count or not spawn:
		return;
	var node = enemy_nodes[enemy].duplicate();
	node.set_type_id(enemy);
	add_child(node);
	spawn.set_entity(node);

func freeze():
	freezed = true;
	for node in get_children():
		node.freeze();
	
func unfreeze():
	freezed = false;
	for node in get_children():
		node.unfreeze();
