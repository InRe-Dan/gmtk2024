class_name Level
extends Node

signal resources_added

@onready var ghost_layer: GhostLayer = $GhostLayer
@onready var buildings_layer: TileMapLayer = $BuildingsLayer

var buildings: Array[Building]

var wheat: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ghost_layer.set_building(load("res://Building/Types/wheat_farm.tres"))
	ResourceDisplay.set_level(self)
	ResourceDisplay.resources_changed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Draw building ghost
	ghost_layer.draw_pattern()


# Intercepts unhandled input
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("submit"):
		build_ghost()


# Production tick
func tick() -> void:
	var total_production: Production = Production.new()
	
	# Generate resources from buildings
	for building: Building in buildings:
		total_production.combine(building.produce())
	
	wheat += total_production.wheat
	
	resources_added.emit()


# Place the ghost as a building
func build_ghost() -> void:
	var building: Building = ghost_layer.building
	if building == null:
		return
	
	var pattern: TileMapPattern = ghost_layer.pattern
	if pattern == null:
		return
	
	# Draw building to the buildings layer
	for cell: Vector2i in pattern.get_used_cells():
		buildings_layer.set_cell(cell + buildings_layer.local_to_map(ghost_layer.get_local_mouse_position()), 0, pattern.get_cell_atlas_coords(cell))
		
	buildings.append(building)
