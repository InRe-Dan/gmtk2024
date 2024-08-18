extends Node2D

@onready var top : Sprite2D = $HeadTop
@onready var bottom : Sprite2D = $HeadBottom

var neck_pieces : Array[Sprite2D]
var time : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var first_neck : Sprite2D = $Node2D/Neck
	neck_pieces = [first_neck]
	for i in range(16):
		var new : Sprite2D = first_neck.duplicate()
		new.position.y += 4 * i
		neck_pieces.append(new)
		$Node2D.add_child(new)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	for neck : Sprite2D in neck_pieces:
		neck.position.x = sin(time * neck.position.y)
