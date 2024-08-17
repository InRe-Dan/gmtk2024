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
	if held_item:
		check_slot_availability(current_slot)
	
	
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
		var column_data: Array[GridSlot]
		for row in range(row_count):
			column_data.append(create_slot(column, row))
		
		matrix.append_array(column_data)


## Creates a grid slot at the specified column and row
func create_slot(col: int, row: int) -> GridSlot:
	var grid_slot: GridSlot = grid_slot_scene.instantiate()
	grid_slot.initialize(Vector2i(col, row))
	
	# Subscribe to hover events
	grid_slot.entered.connect(_on_slot_mouse_entered)
	grid_slot.exited.connect(_on_slot_mouse_exited)
	
	grid_container.add_child(grid_slot)
	

## Checks to see if the passed grid slot is available
func check_slot_availability(slot: GridSlot) -> bool:
	# Iterate over all of the cell positions relative to the root (0, 0) cell
	for relative_position: Vector2i in held_item.item.Placement.relative_cells:
		var grid_pos: Vector2i = slot.grid_position + relative_position
		
		# Check if the relative grid position exists outside the grid bounds
		if grid_pos.x < 0 or grid_pos.x > col_count:
			return false
		if grid_pos.y < 0 or grid_pos.y > row_count:
			return false
		
		# Check if the relative grid slot is occupied
		if slot.state == slot.State.OCCUPIED:
			return false
	
	return true
