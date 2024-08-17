class_name GridSlot
extends TextureRect

signal entered(slot)
signal exited(slot)

@onready var status = $Status

var grid_position: Vector2i

enum State {DEFAULT, OCCUPIED, AVAILABLE}
var state: State = State.DEFAULT

var item_stored = null

var initialized: bool = false


func initialize(position: Vector2i) -> void:
	if initialized: return
	initialized = true

	grid_position = position


func set_color(new_state) -> void:
	match new_state:
		State.OCCUPIED:
			status.color = Color(Color.RED, 0.2)
		State.AVAILABLE:
			status.color = Color(Color.GREEN, 0.2)
		_: status.color = Color(Color.WHITE, 0.0)


## Mouse hovered
func _on_mouse_entered() -> void:
	entered.emit(self)


## Mouse hovered off
func _on_mouse_exited() -> void:
	exited.emit(self)
