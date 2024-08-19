class_name ItemsList
extends ScrollContainer

signal new_item_selected(item)

@export var pick_sound : AudioStreamPlayer
@onready var list_item_scene: PackedScene = preload("res://Item/list_item.tscn")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Populate item list with items from ItemLoader
	var container: VBoxContainer = $VBoxContainer
	var items: Array[Item] = ItemLoader.items
	for item: Item in items:
		var list_item: ListItem = list_item_scene.instantiate() as ListItem
		list_item.item_pressed.connect(_on_item_pressed)
		container.add_child(list_item)
		list_item.initialize(item)


## Item was pressed
func _on_item_pressed(list_item: ListItem) -> void:
	new_item_selected.emit(list_item.item)
	pick_sound.play()
