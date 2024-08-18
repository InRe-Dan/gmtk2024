extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(3):
		PuzzleGenerator.generate_puzzle(Vector2i.ONE * 3)
	for i in range(3):
		PuzzleGenerator.generate_puzzle(Vector2i.ONE * 4)
