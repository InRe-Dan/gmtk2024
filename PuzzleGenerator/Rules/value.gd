class_name ValueRule extends Rule

@export var min : int = 0
@export var max : int = -1

func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	var value : int = 0
	for item : Item in placed:
		value += item.value
	if min > 0 and value < min:
		return false
	if max > 0 and value > max:
		return false
	return true

func get_dragon_request() -> String:
	return get_debug_request()

func get_debug_request() -> String:
	if min == max:
		return "The food's value should be exactly %s!" % [min]
	elif min > 0 and max > 0:
		return "It needs to cost at least %s but no more than %s!" % [min, max]
	elif min > 0:
		return "It should cost at least %s!" % [min]
	else:
		return "It should cost no more than %s!" % [max]

# Slightly different here. There shouldn't be more than two rules involving the same item 
# so we return true in that case so that the other rule gets discarded.
func is_identical_to(other : Rule) -> bool:
	if other is ValueRule:
		return true
	return false

static func generate_valid_rule(gridsize : Vector2i, items : Array[Item]) -> Rule:
	var rule : ValueRule = ValueRule.new()
	var value : int = 0
	for item : Item in items:
		value += item.value
	if value > 80:
		rule.min = value - 15
		return rule
	elif value < 50:
		rule.max = value + 15
		return rule
	return null
