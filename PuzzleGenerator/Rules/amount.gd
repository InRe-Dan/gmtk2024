class_name AmountRule extends Rule

@export var min : int
@export var max : int = -1
@export var item_name : String

func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	var count : int = 0
	for item : Item in placed:
		if item.item_name == item_name:
			count += 1
	if max >= 0 and count > max:
		return false
	if min > 0 and count < min:
		return false
	return true

func get_dragon_request() -> Control:
	var label : Label = Label.new()
	label.text = get_debug_request()
	return label

func get_debug_request() -> String:
	if min == max:
		return "There should be exactly %s of %s" % [min, item_name]
	elif min > 0 and max > 0:
		return "There should be between %s and %s of %s" % [min, max, item_name]
	elif min > 0:
		return "There should be more than %s of %s" % [min, item_name]
	else:
		return "There should be less than %s of %s" % [max, item_name]

# Slightly different here. There shouldn't be more than two rules involving the same item 
# so we return true in that case so that the other rule gets discarded.
func is_identical_to(other : Rule) -> bool:
	if other is not AmountRule:
		return false
	var o : AmountRule = other as AmountRule
	if item_name == o.item_name:
		return true
	return false

static func generate_valid_rule(gridsize : Vector2i, items : Array[Item]) -> Rule:
	var rule : AmountRule = AmountRule.new()
	var names : Array = items.map(func (v): return v.item_name)
	names.shuffle()
	var chosen : String = names.pick_random()
	var number : int = names.count(chosen)
	rule.item_name = chosen
	rule.min = number
	rule.max = number
	return rule
