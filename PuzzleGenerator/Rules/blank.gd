class_name BlankRule extends Rule


func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	return true

func get_dragon_request() -> String:
	return ""

func get_debug_request() -> String:
	return ""

# Slightly different here. There shouldn't be more than two rules involving the same item 
# so we return true in that case so that the other rule gets discarded.
func is_identical_to(other : Rule) -> bool:
	return false

static func generate_valid_rule(gridsize : Vector2i, items : Array[Item]) -> Rule:
	var rule : BlankRule = BlankRule.new()
	return rule
