class_name PuzzleGenerator extends RefCounted

# API example functions

func _init() -> void:
	push_error("PuzzleGenerator._init was called. Class is expected to be used statically.")

static func generate_random_rule(size : Vector2i, placed : Array[Item]) -> Rule:
	var rule : Rule
	var max_attempts : int = 5
	var attempts = 0
	while not rule and attempts < max_attempts:
		var r : int = randi_range(0, 1)
		attempts += 1
		match r:
			0:
				rule = IsInPositionRule.generate_valid_rule(size, placed)
			1:
				rule = IsNotTouchingRule.generate_valid_rule(size, placed)
	return rule

static func generate_puzzle(size : Vector2i) -> Array[Rule]:
	var items_placed : Array[Item]
	for i in range(20):
		var random_item : Item = ItemLoader.items.pick_random()
		var position : Vector2i = Vector2i(randi_range(0, size.x), randi_range(0, size.y))
		var placement : Item.Placement = random_item.get_placement(position, Item.Rotation.NONE)
		random_item.try_place(size, items_placed, placement)
	
	
	var result_rules : Array[Rule]
	var max_attempts : int = 5
	var attempts : int = 0
	while result_rules.size() < 4 and attempts < max_attempts:
		var new_rule : Rule = generate_random_rule(size, items_placed)
		var clash : bool = false
		for rule : Rule in result_rules:
			if not rule: continue
			if rule.is_identical_to(new_rule):
				attempts += 1
				clash = true
		if not clash:
			result_rules.append(new_rule)
			attempts = 0
	
	print("PUZZLE GENERATED =========")
	print("Size    : ", size)
	print("Items   : ", items_placed.map(func (i): return i.item_name))
	print("Rules   :")
	for rule : Rule in result_rules:
		if not rule: continue
		print("    ", rule.get_debug_request())
	print("==========================")
	
	return result_rules
