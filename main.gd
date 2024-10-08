class_name MainScene
extends Control

@onready var grid: Grid = $VBoxContainer/Workspace/HBoxContainer/InfoBox/Zoner/Grid
@onready var rule_list: RuleList = $VBoxContainer/View/MarginContainer/NinePatchRect/MarginContainer/RuleList
@onready var puzzle_timer: Timer = $PuzzleTimer
@onready var timer_label: TextureProgressBar = $VBoxContainer/Workspace/HBoxContainer/InfoBox/Top/Control/TimerLabel
@onready var dragon: Dragon = $VBoxContainer/Dragon
@onready var info_box: InfoBox = $VBoxContainer/Workspace/HBoxContainer/InfoBox
@onready var anger_bar: TextureProgressBar = $VBoxContainer/Workspace/Anger/TextureProgressBar

@onready var music: AudioStreamPlayer = $Music
@onready var tension_music: AudioStreamPlayer = $MusicTension

@onready var tutorial_list: PuzzleList = preload("res://FixedPuzzles/tutorial_puzzles.tres")

var current_puzzle: Puzzle = null

var anger: int = 0
var points: int = 0
var total_expected_cost: int = 0

var tutorial: int = 0


## Node entered the scene tree for the first time
func _ready() -> void:
	grid.solution_submitted.connect(_on_solution_submitted)
	grid.grid_cleared.connect(_on_grid_cleared)
	anger_bar.max_value = Globals.anger_limit
	anger_bar.value = anger_bar.max_value
	tint_bar()
	
	generate_puzzle(tutorial_list.list[0])
	tutorial += 1


## Called every frame
func _process(delta: float) -> void:
	if puzzle_timer.is_stopped(): return
	
	var remaining_time: float = puzzle_timer.time_left
	timer_label.value = remaining_time
	if remaining_time > 18:
		timer_label.tint_progress = Color.from_string("#4cd137", Color.GREEN)
	elif remaining_time > 9:
		timer_label.tint_progress = Color.from_string("#f9ca24", Color.YELLOW)
	else:
		timer_label.tint_progress = Color.from_string("#e84118", Color.RED)


## Generate new puzzle and blank grid
func generate_puzzle(puzzle: Puzzle = null) -> void:	
	dragon.chewing.visible = false
	
	var grid_size: Vector2i
	if puzzle:
		grid_size = Vector2i(puzzle.tray_width, puzzle.tray_height)
		current_puzzle = puzzle
	else:
		grid_size = Vector2i(randi_range(Globals.min_grid_size.x, Globals.max_grid_size.x), randi_range(Globals.min_grid_size.y, Globals.max_grid_size.y))
		current_puzzle = PuzzleGenerator.generate_puzzle_v2(grid_size)
	
	total_expected_cost += current_puzzle.expected_cost
	grid.initialize(grid_size.x, grid_size.y, current_puzzle.rules)
	
	rule_list.new_rules(current_puzzle.rules)
	
	puzzle_timer.wait_time = current_puzzle.time
	timer_label.max_value = puzzle_timer.wait_time
	puzzle_timer.start()


## Grid cleared
func _on_grid_cleared() -> void:
	if tutorial < tutorial_list.list.size():
		generate_puzzle(tutorial_list.list[tutorial])
		tutorial += 1
		return
	
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
		anger += -1
		multiplier = 1
		$Good.play()
	elif fail_list.size() == 2:
		anger += 2
		multiplier = 0.8
		$Bad.play()
	elif fail_list.size() > 4:
		anger += 6
		multiplier = 0.2
		$Bad.play()
	elif fail_list.size() > 2:
		anger += 4
		multiplier = 0.4
		$Bad.play()
	anger = max(0, anger)
	anger_bar.value = anger_bar.max_value - anger
	
	dragon.change_anger(anger + 1, tint_bar())
	
	var budget: int = 0
	for item: Item in items:
		budget += item.value

	points += floor((floor((current_puzzle.rules.size() - fail_list.size()) * 1.5) + floor(min(max(0, current_puzzle.expected_cost - budget),40) / 4.0)) * multiplier)
	info_box._on_points_changed(points)
	if anger >= anger_bar.max_value or Input.is_action_pressed("restart"):
		$LossScreen.start(self)
		


func tint_bar() -> float:
	var anger_percentage: float = anger_bar.value / anger_bar.max_value
	music.volume_db = 0.0
	tension_music.volume_db = -80.0
	if anger_percentage > 0.75:
		anger_bar.tint_progress = Color.from_string("#1f8744", Color.GREEN)
	elif anger_percentage > 0.50:
		anger_bar.tint_progress = Color.from_string("#a1a322", Color.GREEN_YELLOW)
	elif anger_percentage > 0.25:
		anger_bar.tint_progress = Color.from_string("#916023", Color.YELLOW)
	else:
		music.volume_db = -80.0
		tension_music.volume_db = 0.0
		anger_bar.tint_progress = Color.from_string("#962e24", Color.RED)
	
	return anger_percentage


## Out of time
func _on_puzzle_timer_timeout() -> void:
	grid._on_submit()
