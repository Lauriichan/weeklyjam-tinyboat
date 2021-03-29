extends Node

export var min_size : Vector2;
var window_size : Vector2;
var window_position : Vector2;

var mesh2d : MeshInstance2D;

func ready():
	window_size = OS.get_window_size();
	window_position = OS.get_window_position();
	update_mesh(window_size);

func _physics_process(_delta):
	if OS.get_window_size() != window_size:
		window_size = OS.get_window_size();
		if window_size.x < min_size.x || window_size.y < min_size.y:
			if window_size.x < min_size.x:
				window_size.x = min_size.x;
			if window_size.y < min_size.y:
				window_size.y = min_size.y;
			OS.set_window_size(window_size);
			OS.set_window_position(window_position);
		update_mesh(window_size);
	if OS.get_window_position() != window_position:
		window_position = OS.get_window_position();

func update_mesh(var mesh_size : Vector2):
	if mesh2d == null:
		mesh2d = get_node("BackgroundMesh");
		if mesh2d == null:
			return;
	var mesh : ArrayMesh = mesh2d.get_mesh();
	if mesh.get_surface_count() != 0:
		mesh.surface_remove(0);
	if mesh_size.x == mesh_size.y:
		return;
	var arr = [];
	arr.resize(Mesh.ARRAY_MAX);
		
	var ratio_x = 1;
	var ratio_y = 1;
	if mesh_size.x < 1024:
		ratio_x = 1024 / mesh_size.x;
	if mesh_size.y < 1024:
		ratio_y = 1024 / mesh_size.y;
		
	var x = mesh_size.x * ratio_x;
	var y = mesh_size.y * ratio_y;
	
	var game_size = x;
	if game_size > y:
		game_size = y;
	
	var max_game = game_size / 2;
	var min_game = -max_game;
	
	var max_x = ((x + 20) * ratio_y) / 2;
	var min_x = -max_x;
	var max_y = ((y + 20) * ratio_x) / 2;
	var min_y = -max_y;
	
	var verts : PoolVector3Array = PoolVector3Array([
		Vector3(min_x, max_y, 0), 
		Vector3(min_game, max_y, 0), 
		Vector3(max_game, max_y, 0), 
		Vector3(max_x, max_y, 0),
		Vector3(min_x, max_game, 0), 
		Vector3(min_game, max_game, 0), 
		Vector3(max_game, max_game, 0), 
		Vector3(max_x, max_game, 0),
		Vector3(min_x, min_game, 0), 
		Vector3(min_game, min_game, 0), 
		Vector3(max_game, min_game, 0), 
		Vector3(max_x, min_game, 0),
		Vector3(min_x, min_y, 0), 
		Vector3(min_game, min_y, 0), 
		Vector3(max_game, min_y, 0), 
		Vector3(max_x, min_y, 0)
	]);
	
	var normals = PoolVector3Array();
	for vector in verts:
		normals.append(vector.normalized());
		
	var indices = PoolIntArray();
	indices.append_array([0, 1, 5]);
	indices.append_array([0, 4, 5]);
	indices.append_array([1, 2, 6]);
	indices.append_array([1, 5, 6]);
	indices.append_array([2, 3, 7]);
	indices.append_array([2, 6, 7]);
	indices.append_array([4, 5, 9]);
	indices.append_array([4, 8, 9]);
	indices.append_array([6, 7, 11]);
	indices.append_array([6, 10, 11]);
	indices.append_array([8, 9, 13]);
	indices.append_array([8, 12, 13]);
	indices.append_array([9, 10, 14]);
	indices.append_array([9, 13, 14]);
	indices.append_array([10, 11, 15]);
	indices.append_array([10, 14, 15]);
	
	arr[Mesh.ARRAY_VERTEX] = verts;
	arr[Mesh.ARRAY_INDEX] = indices;
	arr[Mesh.ARRAY_NORMAL] = normals;
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr);
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
