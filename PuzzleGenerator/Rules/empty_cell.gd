class_name EmptyCellRule extends Rule

@export var position : Vector2i

func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	for item : Item in placed:
		if position in item.placement.actual_cells:
			return false
	return true

func get_dragon_request() -> Control:
	var label : Label = Label.new()
	label.text = get_debug_request()
	return label

func get_debug_request() -> String:
	return "The should be no item at (%s, %s)" % [position.x, position.y]

func is_identical_to(other : Rule) -> bool:
	if other is not EmptyCellRule:
		return false
	var o : EmptyCellRule = other as EmptyCellRule
	# Since arrays are sorted on set, this comparison is fine.
	if position == o.position:
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
	rule.position = spaces_available.pick_random()
	return rule
