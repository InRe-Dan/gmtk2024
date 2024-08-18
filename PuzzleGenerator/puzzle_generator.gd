class_name PuzzleGenerator extends RefCounted

# API example functions

func _init() -> void:
	push_error("PuzzleGenerator._init was called. Class is expected to be used statically.")

static func generate_random_rule(size : Vector2i, placed : Array[Item]) -> Rule:
	var r : int = randi_range(0, 0)
	match r:
		0:
			return IsInPositionRule.generate_valid_rule(size, placed)

	# Shouldn't be possible. Match/case broken
	assert(false)
	return null

static func generate_puzzle(size : Vector2i) -> Array[Rule]:
	var items_placed : Array[Item]
	for i in range(10):
		var random_item : Item = ItemLoader.items.pick_random()
		var position : Vector2i = Vector2i(randi_range(0, size.x), randi_range(0, size.y))
		var placement : Item.Placement = random_item.get_placement(position, Item.Rotation.NONE)
		random_item.try_place(size, items_placed, placement)
	
	
	var result_rules : Array[Rule]
	while result_rules.size() < 2:
		var new_rule : Rule = generate_random_rule(size, items_placed)
		for rule : Rule in result_rules:
			if rule.is_identical_to(new_rule):
				continue
		result_rules.append(new_rule)
	
	print("PUZZLE GENERATED =========")
	print("Size    :", size)
	print("Items   :", items_placed)
	print("Rules   :")
	for rule : Rule in result_rules:
		print("    ", rule.get_debug_request())
	print("==========================")
	
	return result_rules
