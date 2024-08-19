class_name CountRule extends Rule

@export var max : int

func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	if placed.size() <= max:
		return true
	else:
		return false

func get_dragon_request() -> String:
	return "No more than [color=black]%s[/color] items" % [max]

func get_debug_request() -> String:
	return "No more than %s items" % [max]

# Slightly different here. There shouldn't be more than two rules involving the same item 
# so we return true in that case so that the other rule gets discarded.
func is_identical_to(other : Rule) -> bool:
	if other is CountRule:
		return true
	return false

static func generate_valid_rule(gridsize : Vector2i, items : Array[Item]) -> Rule:
	var rule : CountRule = CountRule.new()
	rule.max = items.size()
	return rule
