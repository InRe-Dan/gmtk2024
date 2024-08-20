extends VBoxContainer

@export var background : Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	background.visible = false

func start(game : Node) -> void:
	visible = true
	background.visible = true
	get_tree().paused = true

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")
