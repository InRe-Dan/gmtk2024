class_name GhostLayer
extends TileMapLayer

var building: Building
var pattern: TileMapPattern


# Sets the building that the ghost is using
func set_building(new_building: Building) -> void:
	building = new_building
	pattern = tile_set.get_pattern(building.pattern_index)


# Draws the pattern to the ghost
func draw_pattern() -> void:
	if building == null:
		return

	# Clear ghost layer
	clear()
	
	if pattern == null:
		return
	
	# Draw building cells to ghost layer
	for cell: Vector2i in pattern.get_used_cells():
		set_cell(cell + local_to_map(get_local_mouse_position()), 0, pattern.get_cell_atlas_coords(cell))
