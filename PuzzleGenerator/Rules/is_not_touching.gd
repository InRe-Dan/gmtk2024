class_name IsNotTouchingRule extends Rule

@export var item_names : Array[String]:
	set(v):
		item_names = v
		item_names.sort()

# Returns true if these two items are directly (not diagonally)
static func check_touch(one : Item, two : Item) -> bool:
	for cell : Vector2i in one.placement.actual_cells:
		for other_cell : Vector2i in two.placement.actual_cells:
			if cell.distance_squared_to(other_cell) <= 1:
				return true
	return false
	

func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	for one in placed:
		for two in placed: 
			if one.item_name == two.item_name:
				continue
			if check_touch(one, two):
				return false
	return true

func get_dragon_request() -> Control:
	var label : Label = Label.new()
	label.text = get_debug_request()
	return label

func get_debug_request() -> String:
	return "The following item's can't be touching: " + str(item_names)

func is_identical_to(other : Rule) -> bool:
	if other is not IsNotTouchingRule:
		return false
	var o : IsNotTouchingRule = other as IsNotTouchingRule
	# Since arrays are sorted on set, this comparison is fine.
	if item_names == o.item_names:
		return true
	return false

static func generate_valid_rule(gridsize : Vector2i, items : Array[Item]) -> Rule:
	var rule : IsNotTouchingRule = IsNotTouchingRule.new()
	if items.size() < 2:
		return null
	var shuffled : Array[Item] = items.duplicate()
	shuffled.shuffle()
	# Just find two items which aren't touching
	for one : Item in shuffled:
		for two : Item in shuffled:
			if one.item_name == two.item_name:
				continue
			elif check_touch(one, two):
				continue
			else:
				rule.item_names = [one.item_name, two.item_name]
				return rule
	return null
