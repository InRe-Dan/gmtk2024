class_name Grid
extends Control

@onready var grid_slot_scene = preload("res://Grid/grid_slot.tscn")
@onready var grid_item_scene = preload("res://Item/grid_item.tscn")
@onready var grid_container: GridContainer = $MarginContainer/GridContainer

var held_item: GridItem = null
var current_slot: GridSlot = null
var can_place: bool = false

var row_count: int
var col_count: int
var matrix

var initialized: bool = false


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize(8,8)


func _input(event: InputEvent) -> void:
	# TODO: REMOVE (testing stuff)
	if event.is_action_pressed("spawn_item"):
		var new_item: GridItem = grid_item_scene.instantiate()
		new_item.initialize(load("res://Item/Items/drumstick.tres"))
		new_item.selected = true
		held_item = new_item
		add_child(new_item)


## Mouse hovered grid slot
func _on_slot_mouse_entered(slot: GridSlot) -> void:
	current_slot = slot
	
	# Clear slot statuses
	for row: Array[GridSlot] in matrix:
		for grid_slot: GridSlot in row:
			grid_slot.set_color(GridSlot.State.DEFAULT)
	
	if held_item:
		check_slot_availability(get_slot_positions())

	
## Mouse hovered off grid slot
func _on_slot_mouse_exited(slot: GridSlot) -> void:
	slot.set_color(GridSlot.State.DEFAULT)


## Initializes the grid to be a certain size
func initialize(columns: int, rows: int) -> void:
	if initialized: return
	initialized = true
	
	row_count = rows
	col_count = columns
	matrix = []
	
	# Resize grid to fit columns and rows specification
	size.x = col_count * Globals.cell_size.x
	size.y = row_count * Globals.cell_size.y
	grid_container.columns = col_count
	
	# Create empty grid slots
	for column in range(col_count):
		var row_data: Array[GridSlot]
		for row in range(row_count):
			row_data.append(create_slot(column, row))
		
		matrix.append(row_data)


## Creates a grid slot at the specified column and row
func create_slot(col: int, row: int) -> GridSlot:
	var grid_slot: GridSlot = grid_slot_scene.instantiate()
	grid_slot.initialize(Vector2i(row, col))
	
	# Subscribe to hover events
	grid_slot.entered.connect(_on_slot_mouse_entered)
	grid_slot.exited.connect(_on_slot_mouse_exited)
	
	grid_container.add_child(grid_slot)
	return grid_slot


## Returns a list of slot positions based on the hovered slot and held item
func get_slot_positions() -> Array[Vector2i]:
	var positions: Array[Vector2i]
	
	# Iterate over all of the cell positions relative to the root (0, 0) cell
	for relative_position: Vector2i in held_item.item.relative_cells:
		positions.append(current_slot.grid_position + relative_position)

	return positions


## Checks to see if slots are available for the passed slot positions
func check_slot_availability(slots: Array[Vector2i]) -> bool:
	var available: bool = true

	# Iterate over slot positions
	for grid_pos in slots:
		var slot: GridSlot = null
		var slot_status: bool = true
		
		# Check if the relative grid position exists outside the grid bounds
		if grid_pos.x < 0 or grid_pos.x > col_count - 1:
			slot_status = false
		if grid_pos.y < 0 or grid_pos.y > row_count - 1:
			slot_status = false
		
		# Fetch slot at given position
		if slot_status:
			slot = matrix[grid_pos.y][grid_pos.x]

			# Check if the slot is occupied
			if slot.item_stored:
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
