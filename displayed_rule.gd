class_name DisplayedRule
extends ColorRect

@onready var label: RichTextLabel = $Condition


## Updates the text of the rule's condition
func update_label(text: String) -> void:
	label.text = text
