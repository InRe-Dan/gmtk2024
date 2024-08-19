class_name ListRule extends Rule

@export var types : Array[int]
@export var amounts : Array[int]


func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	assert(types.size() == amounts.size())
	var dict : Dictionary
	for item : Item in placed:
		for item_type : Item.Type in item.types:
			if dict.has(item_type):
				dict[item_type] += 1
			else:
				dict[item_type] = 1
				
	for i : int in range(types.size()):
		if dict.has(types[i]):
			if dict[types[i]] == amounts[i]:
				pass
			else: return false
		else: return false
	return true

func get_dragon_request() -> String:
	var req : String = ""
	for i : int in range(types.size()):
		req += "[color=black]%s[/color] %s" % [amounts[i], Item.lookup_table[types[i]]]
		if i < types.size() - 1:
			req += ", "
	return req

func get_debug_request() -> String:
	return "Shopping list: %s. Amounts: %s" % [types, amounts]

func is_identical_to(other : Rule) -> bool:
	if other is ListRule:
		return true
	return false

static func generate_valid_rule(gridsize : Vector2i, items : Array[Item]) -> Rule:
	var rule : ListRule = ListRule.new()
	var types_found : Dictionary
	for item : Item in items:
		for item_type : Item.Type in item.types:
			if types_found.has(item_type):
				types_found[item_type] += 1
			else:
				types_found[item_type] = 1

	var type_keys = types_found.keys()
	type_keys.shuffle()
	var random_keys = type_keys.slice(0, min(randi_range(3,4), type_keys.size()))
	for key in random_keys:
		rule.types.append(key)
		rule.amounts.append(types_found[key])

	return rule
