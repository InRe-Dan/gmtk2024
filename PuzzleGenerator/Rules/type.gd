class_name TypeRule extends Rule

@export var type : Item.Type

func _init() -> void:
	priority = 50

func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	for item : Item in placed:
		if not (item.type & type):
			return false
	return true

func get_dragon_request() -> String:
	return "Give %s [color=red]ONLY[/color]" % [Item.lookup_table[type]]

func get_debug_request() -> String:
	return "I want only %s" % [Item.lookup_table[type]]

func is_identical_to(other : Rule) -> bool:
	if other is not TypeRule:
		return false
	var o : TypeRule = other as TypeRule
	if type == o.type:
		return true
	return false

static func generate_valid_rule(gridsize : Vector2i, items : Array[Item]) -> Rule:
	var rule : TypeRule = TypeRule.new()
	var types_found : Dictionary
	for item : Item in items:
		for item_type : Item.Type in item.types:
			if types_found.has(item_type):
				types_found[item_type] += 1
			else:
				types_found[item_type] = 1
	for item_type : Item.Type in types_found.keys():
		if types_found[item_type] == items.size():
			rule.type = item_type
			return rule
	return null
