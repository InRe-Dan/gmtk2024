class_name RuleList
extends VBoxContainer

@onready var rule_display_scene: PackedScene = preload("res://displayed_rule.tscn")
@export var audio : AudioStreamPlayer

var rules: Array[Rule]


func _ready() -> void:
	for i in range(Globals.max_rule_count):
		var rule_display: DisplayedRule = rule_display_scene.instantiate()
		rule_display.name = "Rule" + str(i)
		add_child(rule_display)


## Assigns a new set of rules to the rule list
func new_rules(new_list: Array[Rule]) -> void:
	for display: DisplayedRule in get_children():
		display.label.text = ""
		display.color = Color.DARK_GRAY
	
	rules = new_list
	for i in range(min(rules.size(), get_child_count())):
		var display: DisplayedRule = get_node("Rule" + str(i))
		display.update_condition(rules[i])
	audio.play()


## Marks passed rules as failed
func mark_failed(fail_list: Array[Rule]) -> void:
	for display: DisplayedRule in get_children():
		if fail_list.has(display.rule):
			display.mark_success(false)
		else:
			display.mark_success(true)
