extends CharacterBody2D

const speed = 500.0
@onready var sprite = $AnimatedSprite2D

func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	
	if velocity.x != 0:
		sprite.play("run")
	elif velocity.y > 0:
		sprite.play("down")
	elif velocity.y < 0:
		sprite.play("up")
	else:
		sprite.play("front idle")
		
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
	
		
func player():
	print("hello")
		
		
