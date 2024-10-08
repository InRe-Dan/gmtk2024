class_name Dragon
extends Node2D

@export var menu_mode : bool = false

@onready var head : Sprite2D = $Head
@onready var eyes: Sprite2D = $Head/Eyes
@onready var chewing: Sprite2D = $Head/Chewing

var neck_pieces : Array[Sprite2D]
var time : float = 0

var offset: float

const speed_coeff: float = 0.5
var speed: float = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offset = head.position.x
	var first_neck : Sprite2D = $Node2D/Neck
	neck_pieces = [first_neck]
	for i in range(36):
		var new : Sprite2D = first_neck.duplicate()
		new.position.y += 4 * i
		neck_pieces.append(new)
		$Node2D.add_child(new)


## Sets anger to passed amount
func change_anger(anger: int, percent: float) -> void:
	speed = anger / 2
	if percent < 0.25:
		head.region_rect = Rect2i(2, 96, 35, 20)
		eyes.region_rect = Rect2i(43, 56, 14, 6)
	elif percent < 0.50:
		head.region_rect = Rect2i(2, 72, 35, 20)
		eyes.region_rect = Rect2i(45, 48, 10, 5)
	else:
		head.region_rect = Rect2i(2, 0, 35, 20)
		eyes.region_rect = Rect2i(45, 24, 10, 4)


## Progress chew animation
func progress_chew() -> void:
	chewing.frame += 1
	if chewing.frame == chewing.hframes - 1:
		chewing.frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if menu_mode:
		time += delta
	else:
		time += delta * speed * speed_coeff
	head.position.x = sin(time) * 1.4 + offset
	for neck : Sprite2D in neck_pieces:
		neck.position.x = sin(time + neck.position.y / 16.) * 1.4
		
	if time >= PI * 32: time -= PI * 32
	
	
