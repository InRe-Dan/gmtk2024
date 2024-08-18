class_name IsInPositionRule extends Rule

# * is a wildcard: means that any food can be in this position
@export var item_name : String = "*"
@export var position : Vector2i = Vector2i.ZERO

func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	for item in placed:
		if position in item.placement.get_tiles() and (item.item_name == item_name or item_name == "*"):
			return true
	return false

func get_dragon_request() -> Control:
	var label : Label = Label.new()
	label.text = get_debug_request()
	return label

func get_debug_request() -> String:
	return "%s expected in position (%s, %s)" % [item_name, position.x, position.y]
	
func is_identical_to(other : Rule) -> bool:
	if other is not IsInPositionRule:
		return false
	var o : IsInPositionRule = other as IsInPositionRule
	if position != o.position:
		return false
	if item_name != o.item_name:
		return false
	return true
	
static func generate_valid_rule(gridsize : Vector2i, items : Array[Item]) -> Rule:
	if items.size() == 0: return null 
	var random_item : Item = items.pick_random()
	var random_position : Vector2i = random_item.placement.actual_cells.pick_random()
	var rule : IsInPositionRule = IsInPositionRule.new()
	rule.item_name = random_item.item_name
	rule.position = random_position
	return rule
	
