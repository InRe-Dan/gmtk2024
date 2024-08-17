class_name GridItem
extends Node2D

@onready var texture: TextureRect = $CanvasLayer/TextureRect

var item: Item
var selected: bool = false

var initialized: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), delta * Globals.drag_speed)


## Initializes this 
func initialize(item: Item) -> void:
	if initialized: return
	initialized = true
	
	name = item.name
	texture.texture = item.sprite
