extends StaticBody2D

# List of inputs to rotate through
var inputs = ["wayne", "serotonin", "unnamed"]
var current_index = 0

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_timer_timeout() -> void:
	current_index += 1
	
	if current_index >= inputs.size():
		current_index = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_in_area:
		if Input.is_action_just_pressed("interact"):
			Dialogic.start(inputs[current_index])


var player_in_area = false

func _on_chat_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true
		print("entered")

func _on_chat_detection_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false
		Dialogic.end_timeline()
		print("exitted")
