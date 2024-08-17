extends CanvasLayer

var level: Level

@onready var wheat_display: Label = $VBoxContainer/Wheat


# Receives the level object
func set_level(level_object: Level) -> void:
	level = level_object
	level.connect("resources_added", resources_changed)


# New resources added
# TODO: pass production object to show pop-up effect of newly acquired (or lost) resources
func resources_changed() -> void:
	wheat_display.text = "Wheat: " + str(level.wheat)
