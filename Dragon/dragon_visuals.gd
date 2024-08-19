extends Node2D

@onready var top : Sprite2D = $HeadTop
@onready var bottom : Sprite2D = $HeadBottom

var neck_pieces : Array[Sprite2D]
var time : float = 0

var top_offset: float
var bottom_offset: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top_offset = top.position.x
	bottom_offset = bottom.position.x
	
	var first_neck : Sprite2D = $Node2D/Neck
	neck_pieces = [first_neck]
	for i in range(24):
		var new : Sprite2D = first_neck.duplicate()
		new.position.y += 4 * i
		neck_pieces.append(new)
		$Node2D.add_child(new)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	top.position.x = sin(time) + top_offset
	bottom.position.x = sin(time) + bottom_offset
	for neck : Sprite2D in neck_pieces:
		neck.position.x = sin(time + neck.position.y / 16.)
		
	if time >= PI * 32: time -= PI * 32
	
	
