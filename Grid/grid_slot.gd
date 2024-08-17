class_name GridSlot
extends TextureRect

signal entered(slot)
signal exited(slot)

@onready var status = $Status

var is_hovering: bool = false

enum State {DEFAULT, OCCUPIED, AVAILABLE}
var state: State = State.DEFAULT

var item_stored = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
