class_name InfoBox
extends VBoxContainer

@onready var total_price_label: RichTextLabel = $TotalPrice


## Total grid price changed
func _on_total_price_updated(price: int) -> void:
	total_price_label.text = "Price: [color=ffe600]$" + str(price) + "[/color]"
