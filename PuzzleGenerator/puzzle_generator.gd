class_name PuzzleGenerator extends RefCounted

# API example functions

var foods_available : Array[Food]

func generate_puzzle(size : Vector2i) -> Array[Rule]:
	# initalization
	var grid : Array[Array]
	var result_rules : Array[Rule]
	for x in range(size.x):
		grid.append([])
		for y in range(size.y):
			grid[x].append(null)
	# randomly populate this grid
	var food 
	
	return []
