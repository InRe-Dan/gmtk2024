class_name Ghost
extends TileMapLayer

var pattern: TileMapPattern


func _ready() -> void:
	set_active_pattern(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var cursor_position: Vector2 = get_local_mouse_position()
	
	draw_pattern(cursor_position)
	
	
# Change the ghost's building pattern
func set_active_pattern(value: int = -1) -> void:
	pattern = tile_set.get_pattern(value)


# Draws the pattern to the ghost
func draw_pattern(position: Vector2i) -> void:
	if pattern == null:
		return

	# Clear ghost layer
	clear()

	# Draw building cells to ghost layer
	for cell: Vector2i in pattern.get_used_cells():
		set_cell(cell + local_to_map(position), 0, pattern.get_cell_atlas_coords(cell))
