class_name ListItem
extends Button

signal item_pressed(list_item)

@onready var item_name_label: Label = $HBoxContainer/ItemName
@onready var item_icon_rect: TextureRect = $HBoxContainer/Icon

var item: Item

var initialized: bool = false


## Initializes this listed item
func initialize(new_item: Item) -> void:
	if initialized: return
	initialized = true
	
	item = new_item
	
	item_name_label.text = item.item_name
	item_icon_rect.texture = item.sprite


## Item was pressed
func _on_pressed() -> void:
	item_pressed.emit(self)
