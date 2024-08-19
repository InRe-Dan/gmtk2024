class_name AmountRule extends Rule

@export var min : int
@export var max : int = -1
@export var item_name : String


## Formats the item to a BBCode item name
static func format(item: Item) -> String:
	return "[color=" + item.text_colour.to_html() + "]" + item.item_name + "[/color]"


func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	var count : int = 0
	for item : Item in placed:
		if format(item) == item_name:
			count += 1
	if max >= 0 and count > max:
		return false
	if min > 0 and count < min:
		return false
	return true

func get_dragon_request() -> String:
	if min == max:
		return "%s exactly [color=black]%s[/color]" % [item_name, min]
	elif min > 0 and max > 0:
		return "%s between [color=black]%s[/color] and [color=black]%s[/color]" % [item_name, min, max]
	elif min > 0:
		return "%s [color=black]%s[/color] or more" % [item_name, min]
	else:
		if max == 1:
			return "Only [color=black]1[/color] %s" % [item_name]
		else:
			return "%s [color=black]%s[/color] or less" % [item_name, max]

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
	var names : Array = items.map(func (v: Item): return format(v))
	names.shuffle()
	var chosen : String = names.pick_random()
	var number : int = names.count(chosen)
	rule.item_name = chosen
	rule.min = randi_range(0, number)
	rule.max = randi_range(0, number)
	if rule.max == 0 and rule.min == 0:
		rule.max = randi_range(1, number)
	if rule.min > rule.max:
		rule.max = -1
	return rule
