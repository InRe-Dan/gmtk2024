class_name Level
extends Node

@onready var ghost_layer: GhostLayer = $GhostLayer
@onready var buildings_layer: TileMapLayer = $BuildingsLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ghost_layer.set_building(load("res://Building/Types/wheat_farm.tres"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ghost_layer.draw_pattern()


# Intercepts unhandled input
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("submit"):
		build_ghost()
	

# Place the ghost as a building
func build_ghost() -> void:
	var pattern: TileMapPattern = ghost_layer.pattern
	if pattern == null:
		return
	
	# Draw building to the buildings layer
	for cell: Vector2i in pattern.get_used_cells():
		buildings_layer.set_cell(cell + buildings_layer.local_to_map(ghost_layer.get_local_mouse_position()), 0, pattern.get_cell_atlas_coords(cell))
