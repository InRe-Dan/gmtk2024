class_name GridItem
extends Node2D

@onready var texture_rect: TextureRect = $TextureRect

var item: Item = null
var selected: bool = false

var initialized: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not item or not is_instance_valid(item): return
	texture_rect.texture = item.sprite


## Called every frame to drag the food to the cursor
func drag(delta: float) -> void:
	global_position = lerp(global_position, get_global_mouse_position() - Globals.cell_size_half, delta * Globals.drag_speed)


## Initializes this item
func initialize(new_item: Item) -> void:
	if initialized: return
	initialized = true
	
	item = new_item
	name = item.item_name
