extends HBoxContainer


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var grid: Grid = get_node("Zoner/Grid") as Grid
	var item_list: ItemsList = get_node("ItemsList") as ItemsList
	var info_box: InfoBox = get_node("ColorRect/InfoBox") as InfoBox
	
	item_list.new_item_selected.connect(Callable(grid, "_on_new_item_selected"))
	grid.total_price_updated.connect(Callable(info_box, "_on_total_price_updated"))
	info_box.grid_submitted.connect(Callable(grid, "_on_submit"))
	grid.selected_slot_changed.connect(Callable(info_box, "_on_slot_coordinate_changed"))
