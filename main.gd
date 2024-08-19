extends Control

@onready var grid: Grid = $VBoxContainer/Workspace/HBoxContainer/Zoner/Grid
@onready var rule_list: RuleList = $VBoxContainer/View/MarginContainer/NinePatchRect/MarginContainer/RuleList

var current_puzzle: Puzzle = null


## Node entered the scene tree for the first time
func _ready() -> void:
	grid.solution_submitted.connect(_on_solution_submitted)
	grid.grid_cleared.connect(_on_grid_cleared)
	
	generate_puzzle()


## Generate new puzzle and blank grid
func generate_puzzle() -> void:
	var grid_size: Vector2i = Vector2i(randi_range(Globals.min_grid_size.x, Globals.max_grid_size.x), randi_range(Globals.min_grid_size.y, Globals.max_grid_size.y))
	current_puzzle = PuzzleGenerator.generate_puzzle(grid_size)
	grid.initialize(grid_size.x, grid_size.y)
	
	rule_list.new_rules(current_puzzle.rules)


## Grid cleared
func _on_grid_cleared() -> void:
	generate_puzzle()


## Grid submitted solution
func _on_solution_submitted(grid_items: Array[GridItem], gridsize: Vector2i) -> void:
	# Process grid item data into list of valid items
	var items: Array[Item] = []
	for item: GridItem in grid_items:
		# Determine placement based on root position
		item.item.placement = item.item.get_placement(Vector2i(item.root_slot.grid_position.y, item.root_slot.grid_position.x), Item.Rotation.NONE)
		items.append(item.item)

	if not current_puzzle: return
	
	# Check solution
	var valid: bool = true
	
	var fail_list: Array[Rule] = []
	for rule: Rule in current_puzzle.rules:
		if not rule.is_valid(gridsize, items):
			fail_list.append(rule)
			valid = false
			print(rule.get_debug_request() + " FAILED")
	
	rule_list.mark_failed(fail_list)
	print("solution is " + str(valid))
