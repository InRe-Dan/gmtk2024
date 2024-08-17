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
	
static func generate_valid_rule(gridsize : Vector2i, items : Array[Item]) -> Rule:
	var random_item : Item = items.pick_random()
	var random_position : Vector2i = random_item.placement.get_tiles().pick_random()
	var rule : IsInPositionRule = IsInPositionRule.new()
	rule.item_name = random_item.item_name
	rule.position = random_position
	return rule
	
