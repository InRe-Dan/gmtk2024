class_name ListRule extends Rule

@export var items : Array[String]
@export var amounts : Array[int]

func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	assert(items.size() == amounts.size())
	var dict : Dictionary
	for item : Item in placed:
		if dict.has(item.item_name):
			dict[item.item_name] += 1
		else:
			dict[item.item_name] = 1
	for i : int in range(items.size()):
		if dict.has(items[i]):
			if dict[items[i]] == amounts[i]:
				pass
			else: return false
		else: return false
	return true

func get_dragon_request() -> String:
	var req : String = "I want:"
	for i : int in range(items.size()):
		req += "\n\t%s %s" % [amounts[i], items[i]]
	return req

func get_debug_request() -> String:
	return "Shopping list: %s. Amounts: %s" % [items, amounts]

func is_identical_to(other : Rule) -> bool:
	if other is ListRule:
		return true
	return false

static func generate_valid_rule(gridsize : Vector2i, items : Array[Item]) -> Rule:
	var rule : ListRule = ListRule.new()
	var dict : Dictionary
	for item : Item in items:
		if dict.has(item.item_name):
			dict[item.item_name] += 1
		else:
			dict[item.item_name] = 1
	
	var names : Array = dict.keys()
	names.shuffle()
	for i in range(min(randi_range(3, 4), names.size())):
		rule.items.append(names[i])
		rule.amounts.append(dict[names[i]])
	return rule
