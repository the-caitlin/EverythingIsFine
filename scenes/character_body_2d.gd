extends CharacterBody2D

#references
@onready var item_drop = load("res://scenes/itemDrop.tscn")
@onready var item_spr = $item_spr 
@onready var sprite = $AnimatedSprite2D

var speed = 100.0
var sprint_speed = 150.0
var acceleration = 10.0  
var current_speed = speed  
var drop_pos: Vector2
var items_in_range: Array = []
var carrying_item: bool = false

func _ready(): 
	item_spr.hide()


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
		drop_pos = Vector2(12, 13)
	elif velocity.x < 0:
		sprite.flip_h = true
		drop_pos = Vector2(-12, 13)
		
func pickup_item(item: Area2D):
	item.queue_free()
	carrying_item = true
	item_spr.show()
	
func drop_item():
	item_spr.hide()
	var item = item_drop.instantiate()
	item.position = position + drop_pos
	get_parent().add_child(item)
	carrying_item = false

func _on_pickup_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("item_drop"):
		items_in_range.append(area)
		print(items_in_range)


func _on_pickup_range_area_exited(area: Area2D) -> void:
	if area.is_in_group("item_drop"):
		items_in_range.erase(area)
		print(items_in_range)

func _input(event):
	if event.is_action_pressed("interact"):
		if carrying_item: 
			drop_item()
		else:
			if !items_in_range.is_empty():
				pickup_item(items_in_range.pick_random())
