class_name Grid
extends Control

signal grid_cleared()
signal item_count_changed(count)
signal solution_submitted(items)
signal total_price_updated(new_total)
signal selected_slot_changed(grid_position)

@export var pickup_sound : AudioStreamPlayer
@export var drop_sound : AudioStreamPlayer

@onready var grid_slot_scene = preload("res://Grid/grid_slot.tscn")
@onready var grid_item_scene = preload("res://Item/grid_item.tscn")
@onready var grid_container: GridContainer = $GridContainer
@onready var clear_delay_timer: Timer = $ClearDelay

var held_item: GridItem = null
var current_slot: GridSlot = null
var can_place: bool = false
var drag_offset: Vector2i = Vector2i.ZERO

var row_count: int
var col_count: int
var matrix = []
var items: Array[GridItem] = []

var total_price: int = 0

var is_ready: bool = false


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if held_item and is_instance_valid(held_item):
		held_item.drag(drag_offset, delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("submit"):
		if held_item and is_instance_valid(held_item):
			place_item()
		else:
			pick_item()
	
	if event.is_action_pressed("cancel"):
		pick_item()
		trash_item()
		
	
	if event.is_action_pressed("solve"):
		_on_submit()


## Sets ready status to true
func make_ready() -> void:
	is_ready = true


## Trashes held item
func trash_item() -> void:
	if held_item and is_instance_valid(held_item):
			held_item.queue_free()
			held_item = null
			drag_offset = Vector2i.ZERO
			_on_slot_mouse_exited()
			_on_slot_mouse_entered(current_slot)


## Grid fully cleared
func _on_cleared() -> void:
	grid_cleared.emit()


## Grid submitted
func _on_submit() -> void:
	if not is_ready: return
	is_ready = false

	solution_submitted.emit(items, Vector2i(col_count, row_count))
	
	clear_delay_timer.start()


## New item selected
func _on_new_item_selected(item: Item) -> void:
	trash_item()
	item = item.duplicate()
	var new_item: GridItem = grid_item_scene.instantiate()
	new_item.initialize(item)
	held_item = new_item
	held_item.pickup()
	add_child(new_item)
	new_item.position = get_local_mouse_position()
	if current_slot:
		_on_slot_mouse_entered(current_slot)


## Mouse hovered grid slot
func _on_slot_mouse_entered(slot: GridSlot) -> void:
	current_slot = slot
	if current_slot:
		selected_slot_changed.emit(current_slot.grid_position)
	if held_item and is_instance_valid(held_item):
		can_place = check_slot_availability(get_slot_positions(current_slot, held_item.item))
	elif slot:
		slot.set_color(GridSlot.State.SELECTED)

	
## Mouse hovered off grid slot
func _on_slot_mouse_exited() -> void:
	current_slot = null
	
	# Clear slot statuses
	for row: Array[GridSlot] in matrix:
		for grid_slot: GridSlot in row:
			grid_slot.set_color(GridSlot.State.DEFAULT)
			if is_instance_valid(grid_slot.item_stored):
				grid_slot.item_stored.highlight(false)


## Initializes the grid to be a certain size
func initialize(columns: int, rows: int, rules: Array[Rule]) -> void:
	current_slot = null
	can_place = false
	drag_offset = Vector2i.ZERO
	total_price = 0
	total_price_updated.emit(0)
	item_count_changed.emit(0)
	
	for item: GridItem in items:
		item.queue_free()
	
	items = []
	
	# Free previous slots
	for row: Array[GridSlot] in matrix:
		for slot: GridSlot in row:
			slot.queue_free()
	
	row_count = min(Globals.max_grid_size.y, rows)
	col_count = min(Globals.max_grid_size.x, columns)
	matrix = []
	
	# Resize grid to fit columns and rows specification
	custom_minimum_size.x = col_count * Globals.cell_size.x
	custom_minimum_size.y = row_count * Globals.cell_size.y
	grid_container.columns = col_count
	$Texture.custom_minimum_size = Vector2.ZERO
	$Texture.size = custom_minimum_size + Vector2(16, 16)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(
		(Globals.max_grid_size.x - col_count) * Globals.cell_size.x + 14,
		(Globals.max_grid_size.y - row_count) * Globals.cell_size.y + 16), Globals.grid_tween_time)
	tween.tween_callback(make_ready)
	tween.play()
	
	# Create empty grid slots
	for row in range(row_count):
		var row_data: Array[GridSlot]
		for column in range(col_count):
			row_data.append(create_slot(column, row))
		
		matrix.append(row_data)
	
	# Apply hints to slots
	for rule: Rule in rules:
		# Cover forbidden slots
		if rule is EmptyCellRule:
			for pos: Vector2i in (rule as EmptyCellRule).positions:
				var slot: GridSlot = matrix[pos.y][pos.x]
				slot.cover()
				slot.forbidden = true

		# Color favorable slots
		elif rule is IsInPositionRule:
			rule = rule as IsInPositionRule
			var slot: GridSlot = matrix[rule.position.y][rule.position.x]
			slot.embroid()


## Creates a grid slot at the specified column and row
func create_slot(col: int, row: int) -> GridSlot:
	var grid_slot: GridSlot = grid_slot_scene.instantiate()
	grid_slot.initialize(Vector2i(row, col))
	
	# Subscribe to hover events
	grid_slot.entered.connect(_on_slot_mouse_entered)
	grid_slot.exited.connect(_on_slot_mouse_exited)
	
	grid_container.add_child(grid_slot)
	return grid_slot


## Attempts to place the currently held item
func place_item() -> void:
	if not held_item or not is_instance_valid(held_item): return
	if not can_place or not current_slot: return
	
	# Grab slot corresponding to root of the item
	var root_slot: GridSlot
	var root_pos: Vector2i = current_slot.grid_position - drag_offset
	if root_pos.x >= 0 and root_pos.x < row_count and root_pos.y >= 0 and root_pos.y < col_count:
		root_slot = matrix[root_pos.x][root_pos.y]
	else:
		return
		
	var item: GridItem = held_item
	var hovered_slot: GridSlot = current_slot
	var slots: Array[GridSlot]
	
	held_item = null
	drop_sound.play()
	
	# Iterate over slot positions
	for grid_pos in get_slot_positions(current_slot, item.item):
		# Check if the relative grid position exists outside the grid bounds
		if grid_pos.x >= 0 and grid_pos.x < row_count and grid_pos.y >= 0 and grid_pos.y < col_count:
			slots.append(matrix[grid_pos.x][grid_pos.y])
		else:
			return
	
	# Iterate over slots
	for slot: GridSlot in slots:
		slot.item_stored = item
	
	# Submit item at position
	item.root_slot = root_slot
	item.position = root_slot.position
	total_price += item.item.value
	total_price_updated.emit(total_price)
	items.append(item)
	item_count_changed.emit(items.size())
	item.place()
	
	drag_offset = Vector2i.ZERO
	_on_slot_mouse_exited()
	_on_slot_mouse_entered(hovered_slot)


## Attempts to pick up an item in the hovered slot
func pick_item() -> void:
	if held_item or not current_slot: return
	
	var hovered_slot: GridSlot = current_slot
	
	if is_instance_valid(hovered_slot.item_stored):
		held_item = hovered_slot.item_stored
		held_item.pickup()
	else:
		return
	
	var root_slot: GridSlot = held_item.root_slot
	
	drag_offset = Vector2i.ZERO
	
	# Iterate over slot positions and nullify respective slot's stored item field
	for grid_pos in get_slot_positions(root_slot, held_item.item):
		(matrix[grid_pos.x][grid_pos.y] as GridSlot).item_stored = null
	
	drag_offset = hovered_slot.grid_position - root_slot.grid_position
	
	total_price -= held_item.item.value
	total_price_updated.emit(total_price)
	items.remove_at(items.find(held_item))
	item_count_changed.emit(items.size())
	
	_on_slot_mouse_exited()
	_on_slot_mouse_entered(hovered_slot)
	pickup_sound.play()
	


## Returns a list of slot positions based on the passed slot and passed item
func get_slot_positions(slot: GridSlot, item: Item) -> Array[Vector2i]:
	if not slot: return []
	
	var positions: Array[Vector2i]
	
	# Iterate over all of the cell positions relative to the root (0, 0) cell
	for relative_position: Vector2i in item.relative_cells:
		positions.append(slot.grid_position + Vector2i(relative_position.y, relative_position.x) - drag_offset)

	return positions


## Checks to see if slots are available for the passed slot positions
func check_slot_availability(slots: Array[Vector2i]) -> bool:
	var available: bool = true

	# Iterate over slot positions
	for grid_pos in slots:
		var slot: GridSlot = null
		var slot_status: bool = true
		
		# Check if the relative grid position exists outside the grid bounds
		if grid_pos.x < 0 or grid_pos.x > row_count - 1:
			slot_status = false
		if grid_pos.y < 0 or grid_pos.y > col_count - 1:
			slot_status = false
		
		# Fetch slot at given position
		if slot_status:
			slot = matrix[grid_pos.x][grid_pos.y]

			# Check if the slot is occupied
			if slot.item_stored or slot.forbidden:
				slot_status = false
		
		# Change slot status appearance based on availability report
		if not slot_status:
			if slot:
				slot.set_color(GridSlot.State.OCCUPIED)
			available = false
		else:
			if slot:
				slot.set_color(GridSlot.State.AVAILABLE)
	
	return available


## Clear the board finally
func _on_clear_delay_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(0, Globals.cell_size.y * Globals.max_grid_size.y * 2 + 32), Globals.grid_tween_time)
	tween.tween_callback(_on_cleared)
	tween.play()
