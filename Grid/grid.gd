extends Control

@onready var grid_slot_scene = preload("res://Grid/grid_slot.tscn")
@onready var grid_container: GridContainer = $ColorRect/MarginContainer/GridContainer

var initialized: bool = false


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## Initializes the grid to be a certain size
func initialize(columns: int, rows: int) -> void:
	if initialized: return
	initialized = true
	
	size.x = columns * Globals.cell_size.x
	size.y = rows * Globals.cell_size.y
	grid_container.columns = columns

	for i in range(rows * columns):
		create_slot(i)


## Creates a grid slot
func create_slot(index: int) -> void:
	var grid_slot: GridSlot = grid_slot_scene.instantiate()
	grid_slot.name = str(index)
	
	grid_container.add_child(grid_slot)
