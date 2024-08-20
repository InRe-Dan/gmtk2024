class_name ValueRule extends Rule

@export var min : int = 0
@export var max : int = -1
@export var amount: int = 0

func _init() -> void:
	priority = 4

func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	var value : int = 0
	for item : Item in placed:
		value += item.value
	if min > 0 and value < min:
		return false
	if max > 0 and value > max:
		return false
	if min < 0 and max < 0 and value != amount:
		return false
	return true

func get_dragon_request() -> String:
	if min == max and max > 0:
		return "Cost exactly [color=ffe600]$%s[/color]" % [min]
	elif min > 0 and max > 0:
		return "Cost between [color=ffe600]$%s[/color] and [color=ffe600]$%s[/color]" % [min, max]
	elif min > 0:
		return "Cost more than [color=ffe600]$%s[/color]" % [min]
	else:
		if max > 0:
			return "Cheaper than [color=ffe600]$%s[/color]" % [max]
		else:
			return "Cost exactly [color=ffe600]$%s[/color]" % [amount]

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
	var mode: int = randi_range(0, 1)
	match mode:
		0: rule.min = -1
		_: rule.min = max(0, value - randi_range(0,10))
	mode = randi_range(0, 1)
	match mode:
		0: rule.max = -1
		_: rule.max = value + randi_range(0,10)
	rule.amount = value
	
	return rule
