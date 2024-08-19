extends Control

@onready var grid: Grid = $VBoxContainer/Workspace/HBoxContainer/Zoner/Grid
@onready var rule_list: RuleList = $VBoxContainer/View/MarginContainer/NinePatchRect/MarginContainer/RuleList
@onready var puzzle_timer: Timer = $PuzzleTimer
@onready var timer_label: RichTextLabel = $VBoxContainer/Workspace/HBoxContainer/ColorRect/InfoBox/TimerLabel

var current_puzzle: Puzzle = null

var anger: int = 0


## Node entered the scene tree for the first time
func _ready() -> void:
	grid.solution_submitted.connect(_on_solution_submitted)
	grid.grid_cleared.connect(_on_grid_cleared)
	
	generate_puzzle()


## Called every frame
func _process(delta: float) -> void:
	if puzzle_timer.is_stopped(): return
	
	var remaining_time: float = floor(puzzle_timer.time_left)
	timer_label.text = " Time: "
	if remaining_time > 20:
		timer_label.text += "[color=green]"
	elif remaining_time > 10:
		timer_label.text += "[color=yellow]"
	else:
		timer_label.text += "[color=red]"
	timer_label.text += str(remaining_time) + "[/color]"


## Generate new puzzle and blank grid
func generate_puzzle() -> void:
	var grid_size: Vector2i = Vector2i(randi_range(Globals.min_grid_size.x, Globals.max_grid_size.x), randi_range(Globals.min_grid_size.y, Globals.max_grid_size.y))
	current_puzzle = PuzzleGenerator.generate_puzzle_v2(grid_size)
	grid.initialize(grid_size.x, grid_size.y, current_puzzle.rules)
	
	rule_list.new_rules(current_puzzle.rules)
	
	puzzle_timer.wait_time = current_puzzle.time
	puzzle_timer.start()


## Grid cleared
func _on_grid_cleared() -> void:
	generate_puzzle()


## Grid submitted solution
func _on_solution_submitted(grid_items: Array[GridItem], gridsize: Vector2i) -> void:
	puzzle_timer.stop()
	
	# Process grid item data into list of valid items
	var items: Array[Item] = []
	for item: GridItem in grid_items:
		# Determine placement based on root position
		item.item.placement = item.item.get_placement(Vector2i(item.root_slot.grid_position.y, item.root_slot.grid_position.x), Item.Rotation.NONE)
		items.append(item.item)

	if not current_puzzle: return
	
	var fail_list: Array[Rule] = []
	for rule: Rule in current_puzzle.rules:
		if not rule.is_valid(gridsize, items):
			fail_list.append(rule)
	
	rule_list.mark_failed(fail_list)
	
	if fail_list.size() == 0: anger -= 1
	elif fail_list.size() == 1: anger = 0
	elif fail_list.size() == 2: anger += 1
	elif fail_list.size() > 4: anger += 5
	elif fail_list.size() > 2: anger += 3
	print(anger)


## Out of time
func _on_puzzle_timer_timeout() -> void:
	grid._on_submit()
