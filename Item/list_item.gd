class_name ListItem
extends Button

@onready var item_name_label: Label = $HBoxContainer/ItemName
@onready var item_icon_rect: TextureRect = $HBoxContainer/Icon

var initialized: bool = false


## Initializes this listed item
func initialize(name: String, icon: Texture2D) -> void:
	if initialized: return
	initialized = true

	item_name_label.text = name
	item_icon_rect.texture = icon
