extends Node

## Items file directory
const items_directory: String = "res://Item/Items"

## Maximum grid dimensions in cells
const max_grid_size: Vector2i = Vector2i(8, 8)

## Grid slot cell size in pixels
const cell_size: Vector2i = Vector2i(8, 8)
const cell_size_half: Vector2 = Vector2(cell_size) / 2.0

## Item drag speed
const drag_speed: float = 24.0

## Grid transition time
const grid_tween_time: float = 0.20

func _ready() -> void:
	debug_printout()


func debug_printout() -> void:
	await get_tree().get_root().ready
	for i in range(3):
		PuzzleGenerator.generate_puzzle(Vector2i.ONE * 4)
