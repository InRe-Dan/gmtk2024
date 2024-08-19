class_name GridSlot
extends TextureRect

signal entered(slot)
signal exited(slot)

@onready var status = $Status
@onready var cover_rect = $Cover
@onready var embroidery_rect = $Embroidery

var grid_position: Vector2i

enum State {DEFAULT, OCCUPIED, AVAILABLE, SELECTED}

var item_stored: GridItem = null
var forbidden: bool = false

var initialized: bool = false


func initialize(position: Vector2i) -> void:
	if initialized: return
	initialized = true
	
	custom_minimum_size = Globals.cell_size
	grid_position = position


func set_color(new_state) -> void:
	match new_state:
		State.OCCUPIED:
			status.color = Color(Color.RED, 0.2)
		State.AVAILABLE:
			status.color = Color(Color.GREEN, 0.2)
		State.SELECTED:
			if not item_stored:
				if forbidden:
					status.color = Color(Color.RED, 0.2)
				else:
					status.color = Color(Color.GRAY, 0.1)
			else:
				item_stored.highlight(true)
				status.color = Color(Color.BLUE, 0.2)
		_:
			status.color = Color(Color.WHITE, 0.0)


## Cover the slot
func cover() -> void:
	cover_rect.visible = true
	

## Embroider the slot
func embroid() -> void:
	embroidery_rect.visible = true


## Mouse hovered
func _on_mouse_entered() -> void:
	entered.emit(self)


## Mouse hovered off
func _on_mouse_exited() -> void:
	exited.emit()
