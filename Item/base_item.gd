class_name Item extends Resource

enum Rotation {NONE, RIGHT, DOWN, LEFT}

@export var item_name : String
@export var sprite : Texture2D
# This might have to be a more complex type than just an enum since foods might have different types.
@export var type : int # placeholder type
var placement : Placement

# TODO: REMOVE (used for testing until later)
# TODO: following above ^, set texture size to match placement size
@export var relative_cells: Array[Vector2i] = []

class Placement extends RefCounted:
	var relative_cells: Array[Vector2i]
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
	# If placement is null, return null
	# Otherwise, use placement data and sprite to return the 16x16 image that should be placed on position
	# So for a drumstick this can be called by user twice to get the texture corresponding to the bone and the meat
	return null
	
func matches(other : Item):
	return true if item_name == other.item_name else false

# Other misc functions for values and types and placement
