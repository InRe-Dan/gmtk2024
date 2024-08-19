class_name InfoBox
extends VBoxContainer

signal grid_submitted

@onready var total_price_label: RichTextLabel = $TotalPrice
@onready var submit_button: Button = $Submit
@onready var coordinate_label: Label = $Coordinate


## Total grid price changed
func _on_total_price_updated(price: int) -> void:
	total_price_label.text = " Price: [color=ffe600]$" + str(price) + "[/color]"


## Submit button pressed
func _on_submit_pressed() -> void:
	grid_submitted.emit()
	

## Slot coordinate changed
func _on_slot_coordinate_changed(pos: Vector2i) -> void:
	coordinate_label.text = str(Vector2i(pos.y, pos.x))
