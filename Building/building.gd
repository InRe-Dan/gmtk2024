class_name Building
extends Resource

@export var pattern_index: int = -1

var root_position: Vector2i
var tiles_relative: Array[Vector2i]

@export var production: Production


# Called when the resource enters the scene tree
func _init() -> void:
	pass
