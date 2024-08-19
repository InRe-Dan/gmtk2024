class_name EmptyCellRule extends Rule

func _init() -> void:
	priority = 1

@export var positions : Array[Vector2i]

func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	return true

func get_dragon_request() -> String:
	return ""

func get_debug_request() -> String:
	return ""

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
	for i in range(min(spaces_available.size(), randi_range(3,6))):
		rule.positions.append(spaces_available[i])
	return rule
