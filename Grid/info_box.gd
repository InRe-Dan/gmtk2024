class_name InfoBox
extends VBoxContainer

signal grid_submitted

@onready var total_price_label: RichTextLabel = $Bottom/TotalPrice
@onready var submit_button: Button = $Bottom/Submit
@onready var coordinate_label: Label = $Top/Coordinate
@onready var item_count_label: RichTextLabel = $Bottom/ItemCount
@onready var point_count_label: RichTextLabel = $Top/PointsLabel


## Total grid price changed
func _on_total_price_updated(price: int) -> void:
	total_price_label.text = "[center]Price: [color=ffe600]$" + str(price) + "[/color][/center]"


## Submit button pressed
func _on_submit_pressed() -> void:
	grid_submitted.emit()
	

## Slot coordinate changed
func _on_slot_coordinate_changed(pos: Vector2i) -> void:
	coordinate_label.text = str(Vector2i(pos.y, pos.x))


## Item count changed
func _on_item_count_changed(amount: int) -> void:
	item_count_label.text = "[center]Items: [color=gray]" + str(amount) + "[/color][/center]"
	

## Update point count
func _on_points_changed(point_count: int) -> void:
	point_count_label.text = "[center]Points: [color=gold]" + str(point_count) + "[/color][/center]"
