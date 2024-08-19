class_name PuzzleGenerator extends RefCounted

# API example functions
func _init() -> void:
	push_error("PuzzleGenerator._init was called. Class is expected to be used statically.")
	assert(false)

static func generate_random_rule(size : Vector2i, placed : Array[Item]) -> Rule:
	var rule : Rule
	var max_attempts : int = 5
	var attempts = 0
	while not rule and attempts < max_attempts:
		var r : int = randi_range(0, 6)
		attempts += 1
		match r:
			0:
				rule = IsInPositionRule.generate_valid_rule(size, placed)
			1:
				rule = IsNotTouchingRule.generate_valid_rule(size, placed)
			2:
				rule = BlankRule.generate_valid_rule(size, placed)
			3:
				rule = CountRule.generate_valid_rule(size, placed)
			4:
				rule = ValueRule.generate_valid_rule(size, placed)
			5:
				rule = AmountRule.generate_valid_rule(size, placed)
			6:
				rule = EmptyCellRule.generate_valid_rule(size, placed)
			7:
				rule = ListRule.generate_valid_rule(size, placed)
	return rule

static func generate_puzzle(size : Vector2i) -> Puzzle:
	var items_placed : Array[Item]
	for i in range(40):
		var random_item : Item = ItemLoader.items.pick_random()
		var position : Vector2i = Vector2i(randi_range(0, size.x), randi_range(0, size.y))
		var placement : Item.Placement = random_item.get_placement(position, Item.Rotation.NONE)
		random_item.try_place(size, items_placed, placement)
	

	var result_rules : Array[Rule] = [AmountRule.generate_valid_rule(size, items_placed), IsInPositionRule.generate_valid_rule(size, items_placed)]
	var max_attempts : int = 5
	var attempts : int = 0
	while result_rules.size() < Globals.max_rule_count and attempts < max_attempts:
		var new_rule : Rule = generate_random_rule(size, items_placed)
		var clash : bool = false
		for rule : Rule in result_rules:
			if rule.is_identical_to(new_rule):
				attempts += 1
				clash = true
		if (new_rule) and (not clash) and new_rule.is_compatible_with_puzzle(size, result_rules) and new_rule.is_valid(size, items_placed):
			result_rules.append(new_rule)
			attempts = 0
	
	var puzzle: Puzzle = Puzzle.new()
	puzzle.rules = result_rules
	puzzle.tray_width = size.x
	puzzle.tray_height = size.y
	return puzzle

static func generate_puzzle_v2(size : Vector2i) -> Puzzle:
	var items_placed : Array[Item]
	var rules : Array[Rule]
	var puzzle : Puzzle = Puzzle.new()
	puzzle.tray_width = size.x
	puzzle.tray_height = size.y
	
	# Decide on some items to base the puzzle on
	var items_to_use : Array[Item] = ItemLoader.items
	items_to_use.shuffle()
	items_to_use.resize(randi_range(4, 8))
	for i in range(40):
		var random_item : Item = items_to_use.pick_random().duplicate()
		var position : Vector2i = Vector2i(randi_range(0, size.x), randi_range(0, size.y))
		var placement : Item.Placement = random_item.get_placement(position, Item.Rotation.NONE)
		random_item.try_place(size, items_placed, placement)
		
	rules.append(ListRule.generate_valid_rule(size, items_placed))
	rules.append(ValueRule.generate_valid_rule(size, items_placed))
	# Value rule might fail
	if not rules.back():
		rules.pop_back()
	var max_attempts : int = 5
	var attempts : int = 0
	while rules.size() < Globals.max_rule_count and attempts < max_attempts:
		var new_rule : Rule = generate_random_rule(size, items_placed)
		var clash : bool = false
		for rule : Rule in rules:
			if rule.is_identical_to(new_rule):
				attempts += 1
				clash = true
		if (new_rule) and (not clash) and new_rule.is_compatible_with_puzzle(size, rules) and new_rule.is_valid(size, items_placed):
			rules.append(new_rule)
			attempts = 0
	
	puzzle.rules = rules
	puzzle.rules.sort_custom(rule_sorter)
	puzzle.time = 60
	return puzzle

static func rule_sorter(a : Rule, b : Rule) -> bool:
	return a.priority >= b.priority
