extends Control

@onready var score_label: RichTextLabel = $VBoxContainer/Score
@onready var jaw: AnimatedSprite2D = $Jaw
@onready var jaw_delay: Timer = $JawDelay


func start(game : MainScene) -> void:
	jaw.stop()
	score_label.text = "[center]Score: [color=gold]" + str(game.points) + "[/color][/center]"
	visible = true
	get_tree().paused = true
	jaw_delay.start()

func _on_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	get_tree().change_scene_to_file("res://main.tscn")


func _on_jaw_delay_timeout() -> void:
	jaw.play()
