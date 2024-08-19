class_name GridItem
extends Node2D

@onready var texture_rect: TextureRect = $TextureRect

var item: Item = null
var root_slot: GridSlot = null

var initialized: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not item or not is_instance_valid(item): return
	texture_rect.texture = item.sprite
	texture_rect.size = texture_rect.texture.get_size()


## Called every frame to drag the food to the cursor
func drag(drag_offset: Vector2i, delta: float) -> void:
	global_position = lerp(global_position, get_global_mouse_position() - Vector2(Globals.cell_size) - Vector2(Vector2i(drag_offset.y, drag_offset.x) * Globals.cell_size * 2.0), delta * Globals.drag_speed)


## Initializes this item
func initialize(new_item: Item) -> void:
	if initialized: return
	initialized = true
	
	item = new_item
	name = item.item_name
	

## Item is picked up
func pickup() -> void:
	z_index = 100
	scale = Vector2(1.125, 1.125)
	highlight(true)
	
	
## Item is placed down
func place() -> void:
	z_index = 0
	scale = Vector2(1, 1)
	

## Sets item highlighted
func highlight(state: bool) -> void:
	if state:
		modulate = Color(1.1, 1.1, 1.1)
	else:
		modulate = Color(1.0, 1.0, 1.0)
