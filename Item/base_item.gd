class_name Item extends Resource

# Default rotation is UP
enum Rotation {NONE = 0, 
RIGHT = 1, 
DOWN = 2, 
LEFT = 3}

@export var item_name : String
@export var sprite : Texture2D:
	set(value):
		sprite = value
		init_relative_cells()

# This might have to be a more complex type than just an enum since foods might have different types.
@export var type : int # placeholder type
var placement : Placement

var relative_cells: Array[Vector2i]

static func rotate_clockwise(v : Vector2i) -> Vector2i:
	# Matrix multiplication
	#  0 1 * x =  0 * x + 1 * y
	# -1 0   y   -1 * x + 0 * y
	return Vector2i(v.y, -v.x)

class Placement extends RefCounted:
	var relative_cells: Array[Vector2i]
	var actual_cells : Array[Vector2i]
	var item : Item
	var rotation : Item.Rotation
	var position : Vector2i
	func _init(i : Item, pos : Vector2i, rot : Item.Rotation) -> void:
		item = i
		position = pos
		for cell : Vector2i in item.relative_cells:
			for r in range(rotation):
				cell = Item.rotate_clockwise(cell)
			relative_cells.append(cell)
			actual_cells.append(cell + position)

func get_placement(position : Vector2i, rotation : Rotation) -> Placement:
	return Placement.new(self, position, rotation)

func try_place(grid_size : Vector2i, placed : Array[Item], placement : Placement) -> bool:
	# Assess grid to see if object can be placed here
	# If it can, set our own placement and return true
	# If not, return false
	return false

func get_sprite(position : Vector2i) -> ImageTexture:
	if not placement:
		return null
	if not position in placement.actual_cells:
		return null

	var index : int = placement.actual_cells.find(position)
	var region : Rect2i = Rect2i(placement.relative_cells[index], Globals.cell_size)
	var cut : Image = sprite.get_image().get_region(region)
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
