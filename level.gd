class_name Level
extends Node2D

signal resources_added

const PAN_SPEED = 100.0

@onready var ghost_layer: GhostLayer = $GhostLayer
@onready var buildings_layer: TileMapLayer = $BuildingsLayer

var buildings: Dictionary # Vector2i -> Building
var last_production : Production

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
	var coordinate : Vector2i = buildings_layer.local_to_map(buildings_layer.get_local_mouse_position())
	$Label.text = str(coordinate)
	print(buildings.has(coordinate))
	if buildings.has(coordinate):
		var building : Building = buildings[coordinate]
		$Label.text = building.name + "\n" + building.production.get_string()
	$Label.global_position = get_global_mouse_position() + Vector2(20, 20)


# Intercepts unhandled input
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("submit"):
		build_ghost()


# Production tick
func tick() -> void:
	last_production = Production.new()
	
	# Generate resources from buildings
	for building: Building in buildings.values():
		last_production.combine(building.produce())
		
	wheat += last_production.wheat
	
	
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
		var coordinate : Vector2i = cell + buildings_layer.local_to_map(ghost_layer.get_local_mouse_position())
		buildings_layer.set_cell(coordinate, 0, pattern.get_cell_atlas_coords(cell))
		buildings[coordinate] = building
