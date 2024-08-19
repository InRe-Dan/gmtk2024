class_name EmptyCellRule extends Rule

func _init() -> void:
	priority = 1

@export var positions : Array[Vector2i]

func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	for item : Item in placed:
		for position: Vector2i in positions:
			if position in item.placement.actual_cells:
				return false
	return true

func get_dragon_request() -> String:
	var req : String = "[color=grey]Nothing[/color] at "
	for i : int in range(positions.size()):
		req += "[color=black](%s, %s)[/color]" % [positions[i].x, positions[i].y]
		if i < positions.size() - 1:
			req += ", "
	return req

func get_debug_request() -> String:
	return "There should be no items at %s" % [positions]

func is_identical_to(other : Rule) -> bool:
	if other is EmptyCellRule:
		return true
	return false

static func generate_valid_rule(gridsize : Vector2i, items : Array[Item]) -> Rule:
	var rule : EmptyCellRule = EmptyCellRule.new()
	var spaces_available : Array[Vector2i]
	for i in range(gridsize.x):
		for j in range(gridsize.y):
			spaces_available.append(Vector2i(i, j))
	for item : Item in items:
		for tile : Vector2i in item.placement.actual_cells:
			spaces_available.erase(tile)
	if spaces_available.size() == 0:
		return null
	spaces_available.shuffle()
	for i in range(min(spaces_available.size(), randi_range(3,4))):
		rule.positions.append(spaces_available[i])
	return rule
