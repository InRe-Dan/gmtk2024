extends Control

@export var background : Control
@onready var score_label: RichTextLabel = $VBoxContainer/Score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	background.visible = false

func start(game : MainScene) -> void:
	score_label.text = "[center]Score: [color=gold]" + str(game.points) + "[/color][/center]"
	visible = true
	background.visible = true
	get_tree().paused = true

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")
