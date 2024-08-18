extends HBoxContainer


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var grid: Grid = get_node("Grid") as Grid
	var item_list: ItemsList = get_node("ItemsList") as ItemsList
	
	item_list.new_item_selected.connect(Callable(grid, "_on_new_item_selected"))
