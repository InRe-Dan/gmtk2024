class_name DisplayedRule
extends ColorRect

@onready var label: RichTextLabel = $Condition

var rule: Rule = null


## Updates the condition
func update_condition(new_rule: Rule) -> void:
	if new_rule:
		rule = new_rule
		label.text = rule.get_dragon_request()
	else: label.text = ""


## Marks this rule as either success or failure
func mark_success(success: bool) -> void:
	if success:
		color = Color(Color.DARK_GREEN, 0.2)
	else:
		color = Color(Color.DARK_RED, 0.2)
