class_name Dragon
extends Node2D

@onready var head : Sprite2D = $Head

var neck_pieces : Array[Sprite2D]
var time : float = 0

var offset: float

const speed_coeff: float = 0.5
var speed: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offset = head.position.x
	
	var first_neck : Sprite2D = $Node2D/Neck
	neck_pieces = [first_neck]
	for i in range(24):
		var new : Sprite2D = first_neck.duplicate()
		new.position.y += 4 * i
		neck_pieces.append(new)
		$Node2D.add_child(new)


## Sets anger to passed amount
func change_anger(anger: int) -> void:
	speed = anger
	if anger > 20:
		head.region_rect = Rect2i(2, 96, 35, 21)
	elif anger > 10:
		head.region_rect = Rect2i(2, 72, 35, 21)
	else:
		head.region_rect = Rect2i(2, 0, 35, 20)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += 0.0075 + delta * speed * speed_coeff
	head.position.x = sin(time) + offset
	for neck : Sprite2D in neck_pieces:
		neck.position.x = sin(time + neck.position.y / 16.)
		
	if time >= PI * 32: time -= PI * 32
	
	
