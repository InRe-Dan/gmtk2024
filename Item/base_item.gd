class_name Item extends Resource

# Default rotation is UP
enum Rotation {NONE = 0, 
RIGHT = 1, 
DOWN = 2, 
LEFT = 3}

# Item names should be unique
@export var item_name : String
# Setter regenerates the relative cell data
@export var sprite : Texture2D:
	set(value):
		sprite = value
		init_relative_cells()
		
## Monetary value of the item
@export var value: int = 0
@export var text_colour : Color = Color.BLACK

# This might have to be a more complex type than just an enum since foods might have different types.
enum Type {
	MEAT = 1 << 0,
	FRUIT = 1 << 1,
	VEGETABLE = 1 << 2,
	PASTRY = 1 << 3,
	SEAFOOD = 1 << 4,
	DAIRY = 1 << 5
}
@export var types : Array[Type]:
	set(a):
		type = 0
		for value in a:
			type = type | value
		types = a
var type : int

# Should be formatted in such a way that "I want NO x" makes sense
static var lookup_table : Dictionary = { # Type -> BBCode String
	Type.MEAT: "[color=#c23616]Meat[/color]",
	Type.FRUIT: "[color=#9c88ff]Fruit[/color]",
	Type.VEGETABLE: "[color=#6ab04c]Vegetable[/color]",
	Type.SEAFOOD: "[color=#30336b]Seafood[/color]",
	Type.PASTRY: "[color=#f8c291]Pastry[/color]",
	Type.DAIRY: "[color=#dff9fb]Dairy[/color]"
}


# Placement is null for unplaced items
var placement : Placement

# Relative cells in the default UP orientation
# Do not modify manually!
var relative_cells: Array[Vector2i]

# Helper function used for rotating relative cells in placements
# Rotates a vector2i around it's origin by 90 degrees clockwise
static func rotate_clockwise(v : Vector2i) -> Vector2i:
	# Matrix multiplication
	#  0 1 * x =  0 * x + 1 * y
	# -1 0   y   -1 * x + 0 * y
	return Vector2i(v.y, -v.x)

# Helper class representing an item's placement
class Placement extends RefCounted:
	var item : Item
	var rotation : Item.Rotation
	var position : Vector2i
	var relative_cells: Array[Vector2i]
	var actual_cells : Array[Vector2i]
	func _init(i : Item, pos : Vector2i, rot : Item.Rotation) -> void:
		item = i
		position = pos
		for cell : Vector2i in item.relative_cells:
			for r in range(rotation):
				cell = Item.rotate_clockwise(cell)
			relative_cells.append(cell)
			actual_cells.append(Vector2i(cell.x + position.x, cell.y + position.y))

# Gets a possible placement for the current item with a given position and rotation
# Does not do any validation. This should be done with Item.try_place
func get_placement(position : Vector2i, rotation : Rotation) -> Placement:
	return Placement.new(self, position, rotation)

# Checks for bounds and collisions with other already placed items
# If there are no issues, returns true, sets the placement of the item
# and appends the item to the given placed array.
func try_place(grid_size : Vector2i, placed : Array[Item], placement : Placement) -> bool:
	# Check if all positions are in range of the grid_size
	if not placement.actual_cells.all(func (v): return true if v.x in range(0, grid_size.x) and v.y in range(0, grid_size.y) else false):
		return false
	# Then check if any of the cells of our placement clash with others
	var used_positions : Array[Vector2i]
	for item : Item in placed:
		used_positions.append_array(item.placement.actual_cells)
	for cell : Vector2i in placement.actual_cells:
		if cell in used_positions: return false
	# If not, complete operation and return true
	self.placement = placement
	placed.append(self)
	return true

# Gets the texture that should be placed at the given position on a grid
# Accounts for rotation and position.
# Returns null if there is no placement or if the position is empty for this item
func get_sprite(position : Vector2i) -> ImageTexture:
	if not placement:
		return null
	if not position in placement.actual_cells:
		return null

	var index : int = placement.actual_cells.find(position)
	var region : Rect2i = Rect2i(placement.relative_cells[index], Globals.cell_size)
	var cut : Image = sprite.get_image().get_region(region)
	for i in range(placement.rotation):
		cut.rotate_90(CLOCKWISE)
	var texture : ImageTexture = ImageTexture.create_from_image(cut)
	return texture
	
# Called as part of the sprite getter
# Initializes relative_cells based on size and values in the sprite
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
	
# Returns true iff. item names match
func matches(other : Item):
	return true if item_name == other.item_name else false

# Other misc functions for values and types and placement
