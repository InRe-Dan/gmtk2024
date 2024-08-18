extends ScrollContainer

@onready var list_item_scene: PackedScene = preload("res://Item/list_item.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Populate item list with items from ItemLoader
	var items: Array[Item] = ItemLoader.items
	for item: Item in items:
		var list_item: ListItem = list_item_scene.instantiate() as ListItem
		add_child(list_item)
		list_item.initialize(item.item_name, item.sprite)
