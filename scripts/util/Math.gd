class_name Math

static func point_on_circle_with(var radius : float, var rotation : float, var current : float):
	return point_on_circle(radius, rotation - current);

static func point_on_circle(var radius : float, var rotation : float):
	return Vector2(radius * sin(rotation), radius * cos(rotation));
	
static func radius_of_circle(var point : Vector2) -> float:
	return sqrt(point.x * point.x + point.y * point.y);
	
