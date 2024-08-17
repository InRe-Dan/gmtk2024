extends Node

var items : Array[Item]


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir_access = DirAccess.open(Globals.items_directory)
	if dir_access:
		var files : PackedStringArray = dir_access.get_files()
		for file in files:
			if file.ends_with(".tres"):
				var loaded : Resource = load(Globals.items_directory + "/" + file)
				assert(loaded is Item)
				if loaded is Item:
					items.append(loaded)
	else:
		push_error("Opening item directory failed: " + str(DirAccess.get_open_error()))

	var debug_str : String = "Items loaded: \n"
	for item in items:
		debug_str += "    " + item.item_name + "\n"
	print(debug_str)
		
