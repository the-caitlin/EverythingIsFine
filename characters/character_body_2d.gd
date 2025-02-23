extends CharacterBody2D

var speed = 100.0
var sprint_speed = 150.0
var acceleration = 10.0  
var current_speed = speed  

@onready var sprite = $AnimatedSprite2D


func _physics_process(_delta):
	# Get direction based on input
	var direction = Input.get_vector("left", "right", "up", "down")

	# Check if the Shift key is held for sprinting
	if Input.is_key_pressed(KEY_SHIFT):
		current_speed = lerp(current_speed, sprint_speed, acceleration * _delta)  # Gradually increase speed to sprint
	else:
		current_speed = lerp(current_speed, speed, acceleration * _delta)  # Gradually decrease speed to walk
	
	# Calculate velocity and move the player
	velocity = direction * current_speed
	move_and_slide()

	# Handle animations based on movement direction
	if velocity.x != 0:
		sprite.play("run")
	elif velocity.y < 0:
		sprite.play("up")
	elif velocity.y > 0:
		sprite.play("down")
	else:
		sprite.play("front idle")

	# Flip sprite horizontally based on movement direction
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
		
func player():
	pass
	
