class_name Item extends Resource

enum Rotation {NONE, RIGHT, DOWN, LEFT}

@export var item_name : String
@export var sprite : Texture2D:
	set(value):
		sprite = value
		init_relative_cells()

# This might have to be a more complex type than just an enum since foods might have different types.
@export var type : int # placeholder type
var placement : Placement

# TODO: REMOVE (used for testing until later)
# TODO: following above ^, set texture size to match placement size
var relative_cells: Array[Vector2i]

class Placement extends RefCounted:
	var relative_cells: Array[Vector2i]
	var item : Item
	func get_cell() -> Array[Vector2i]:
		# TODO return all cell positions on the grid used by this placement
		return []

func get_placement(rotation : Rotation, position : Vector2i) -> Placement:
	
	# Generate placement object for this item, taking size/shape into account
	# Just return it
	return null

func try_place(grid_size : Vector2i, placed : Array[Item], placement : Placement) -> bool:
	# Assess grid to see if object can be placed here
	# If it can, set our own placement and return true
	# If not, return false
	return false

func get_sprite(position : Vector2i) -> ImageTexture:
	if placement:
		pass
	# If placement is null, return null
	# Otherwise, use placement data and sprite to return the 16x16 image that should be placed on position
	# So for a drumstick this can be called by user twice to get the texture corresponding to the bone and the meat
	return null
	
func init_relative_cells() -> void:
	relative_cells = []
	var image : Image = sprite.get_image()
	assert(Globals.cell_size.x == Globals.cell_size.y)
	var cell_size : int = Globals.cell_size.x
	assert(image.get_width() % cell_size == 0 and image.get_height() % cell_size == 0)
	var cell_grid_size : Vector2i = image.get_size() / cell_size
	for x in range(cell_grid_size.x):
		for y in range(cell_grid_size.y):
			var region : Rect2i = Rect2i(Vector2i(x, y) * cell_size, cell_size * Vector2i.ONE)
			var cell : Image = image.get_region(region)
			if not cell.is_invisible():
				relative_cells.append(Vector2i(x, y))
	
func matches(other : Item):
	return true if item_name == other.item_name else false

# Other misc functions for values and types and placement
