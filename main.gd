extends Control

@onready var grid: Grid = $VBoxContainer/Workspace/HBoxContainer/InfoBox/Zoner/Grid
@onready var rule_list: RuleList = $VBoxContainer/View/MarginContainer/NinePatchRect/MarginContainer/RuleList
@onready var puzzle_timer: Timer = $PuzzleTimer
@onready var timer_label: TextureProgressBar = $VBoxContainer/Workspace/HBoxContainer/InfoBox/Top/Control/TimerLabel
@onready var dragon: Dragon = $VBoxContainer/Dragon
@onready var info_box: InfoBox = $VBoxContainer/Workspace/HBoxContainer/InfoBox

var current_puzzle: Puzzle = null

var anger: int = 0
var points: int = 0


## Node entered the scene tree for the first time
func _ready() -> void:
	grid.solution_submitted.connect(_on_solution_submitted)
	grid.grid_cleared.connect(_on_grid_cleared)
	
	generate_puzzle()


## Called every frame
func _process(delta: float) -> void:
	if puzzle_timer.is_stopped(): return
	
	var remaining_time: float = puzzle_timer.time_left
	timer_label.value = remaining_time
	if remaining_time > 20:
		timer_label.tint_progress = Color.from_string("#4cd137", Color.GREEN)
	elif remaining_time > 10:
		timer_label.tint_progress = Color.from_string("#f9ca24", Color.YELLOW)
	else:
		timer_label.tint_progress = Color.from_string("#e84118", Color.RED)


## Generate new puzzle and blank grid
func generate_puzzle() -> void:
	dragon.chewing.visible = false
	
	var grid_size: Vector2i = Vector2i(randi_range(Globals.min_grid_size.x, Globals.max_grid_size.x), randi_range(Globals.min_grid_size.y, Globals.max_grid_size.y))
	current_puzzle = PuzzleGenerator.generate_puzzle_v2(grid_size)
	grid.initialize(grid_size.x, grid_size.y, current_puzzle.rules)
	
	rule_list.new_rules(current_puzzle.rules)
	
	puzzle_timer.wait_time = current_puzzle.time
	timer_label.max_value = puzzle_timer.wait_time
	puzzle_timer.start()


## Grid cleared
func _on_grid_cleared() -> void:
	generate_puzzle()


## Grid submitted solution
func _on_solution_submitted(grid_items: Array[GridItem], gridsize: Vector2i) -> void:
	puzzle_timer.stop()
	dragon.chewing.visible = true
	
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
	
	var multiplier: int = 0
	if fail_list.size() == 0:
		anger += -2
		multiplier = 2
		$Great.play()
	elif fail_list.size() == 1:
		anger += 0
		multiplier = 1
		$Good.play()
	elif fail_list.size() == 2:
		anger += 1
		multiplier = 1
		$Good.play()
	elif fail_list.size() > 4:
		anger += 5
		multiplier = 0
		$Bad.play()
	elif fail_list.size() > 2:
		anger += 3
		multiplier = 0
		$Bad.play()
	anger = max(0, anger)
	dragon.change_anger(anger + 1)
	
	points += (current_puzzle.rules.size() - fail_list.size()) * multiplier
	info_box._on_points_changed(points)


## Out of time
func _on_puzzle_timer_timeout() -> void:
	grid._on_submit()
