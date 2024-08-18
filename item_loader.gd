extends Node

# To prevent program-wide state changes, this always returns a duplicate.
var items : Array[Item]:
	get:
		var copy: Array[Item]
		for item: Item in items:
			copy.append(item.duplicate())
		return copy


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var new_items : Array[Item] = []
	var dir_access = DirAccess.open(Globals.items_directory)
	if dir_access:
		var files : PackedStringArray = dir_access.get_files()
		for file in files:
			if file.ends_with(".tres"):
				var loaded : Resource = load(Globals.items_directory + "/" + file)
				assert(loaded is Item)
				if loaded is Item:
					new_items.append(loaded)
	else:
		push_error("Opening item directory failed: " + str(DirAccess.get_open_error()))

	items = new_items
	var debug_str : String = "Items loaded: \n"
	for item in items:
		debug_str += "    " + item.item_name + "\n"
	print(debug_str)
		
