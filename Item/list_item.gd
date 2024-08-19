class_name ListItem
extends Button

signal item_pressed(list_item)

@onready var item_name_label: Label = $HBoxContainer/ItemName
@onready var item_icon_rect: TextureRect = $HBoxContainer/Icon
@onready var item_price_label: Label = $HBoxContainer/Price

var item: Item

var initialized: bool = false


## Initializes this listed item
func initialize(new_item: Item) -> void:
	if initialized: return
	initialized = true
	
	item = new_item
	
	item_name_label.text = item.item_name
	item_icon_rect.texture = item.sprite
	item_price_label.text = "$" + str(item.value)
	
	for type: Item.Type in item.types:
		tooltip_text += Item.lookup_table[type]
		tooltip_text += "  "


## Item was pressed
func _on_pressed() -> void:
	item_pressed.emit(self)


## Custom tooltip ref
func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip = preload("res://Item/list_tool_tip.tscn").instantiate()
	tooltip.text = for_text
	tooltip.modulate = Color(Color.WHITE, 1.1)
	return tooltip
