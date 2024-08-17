extends Camera2D

const PAN_SPEED = 100.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pan_direction : Vector2 = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	position += pan_direction * delta * PAN_SPEED
