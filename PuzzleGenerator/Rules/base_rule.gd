class_name Rule extends Resource

# Analyze a grid and arrangement of items to see if this rule is valid
func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	push_error("Unimplemented Rule.is_valid")
	return false

# Return a node representing the request for this rule
# Node type TBD, Control is a placeholder
func get_dragon_request() -> Control:
	push_error("Unimplemented Rule.get_dragon_request")
	return null

# Similar to get_dragon_request, but instead returns in a string
# format to be used in debug and development
func get_debug_request() -> String:
	push_error("Unimplemented Rule.get_debug_request")
	return ""
	
# Given a tray, determine a possible rule of this type that would be valid
static func generate_valid_rule(gridsize : Vector2i, items : Array[Item]) -> Rule:
	push_error("Unimplemented Rule.Generate_valid_rule")
	return null
	
func is_identical_to(other : Rule) -> bool:
	push_error("Unimplemented Rule.is_identical_to")
	return false
	
# Returns true if the rule should be compatible with puzzle parameters
# Default implementation returns true
func is_compatible_with_puzzle(gridsize : Vector2i, rules : Array[Rule]) -> bool:
	return true
