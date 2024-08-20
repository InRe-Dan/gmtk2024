class_name MessageRule extends Rule

@export var message: String = ""


func _init() -> void:
	priority = 1000

func is_valid(gridsize : Vector2i, placed : Array[Item]) -> bool:
	return true

func get_dragon_request() -> String:
	return message

func get_debug_request() -> String:
	return ""

# Slightly different here. There shouldn't be more than two rules involving the same item 
# so we return true in that case so that the other rule gets discarded.
func is_identical_to(other : Rule) -> bool:
	return false

static func generate_valid_rule(gridsize : Vector2i, items : Array[Item]) -> Rule:
	var rule : MessageRule = MessageRule.new()
	return rule
