extends CharacterBody2D

#references
@onready var item_drop = load("res://scenes/itemDrop.tscn")
@onready var item_spr = $item_spr 
@onready var item_pan = $item_pan
@onready var sprite = $AnimatedSprite2D
@onready var oven = $oven
@onready var pan_drop = load("res://scenes/pan.tscn")

var speed = 100.0
var sprint_speed = 150.0
var acceleration = 10.0  
var current_speed = speed  
var drop_pos: Vector2
var items_in_range: Array = []
var carrying_item: bool = false
var near_basket: bool = false
var near_pan: bool = false
var near_oven: bool = false
var carrying_pan: bool = false

func _ready(): 
	item_spr.hide()
	item_pan.hide()

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
	if !near_pan: 
		item.queue_free()
		carrying_item = true
		item_spr.show()
	else:
		item.queue_free()
		carrying_pan = true
		item_pan.show()
		
	
func drop_item():
	item_spr.hide()
	var item = item_drop.instantiate()
	item.position = position + drop_pos
	get_parent().add_child(item)
	carrying_item = false
	
func erase_item():
	item_spr.hide()
	carrying_item = false
	
func place_pan(): 
	item_pan.hide()
	carrying_pan = false
	var pan = pan_drop.instantiate()
	pan.position = Vector2(89, 557)
	pan.rotate(-90)
	get_parent().add_child(pan)
	

func _on_pickup_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("item_drop"):
		items_in_range.append(area)
		print(items_in_range)
	if area.is_in_group("basket"):
		near_basket = true
	if area.is_in_group("item_pan"):
		items_in_range.append(area)
		print(items_in_range)
		near_pan = true
	if area.is_in_group("oven"):
		near_oven = true

func _on_pickup_range_area_exited(area: Area2D) -> void:
	if area.is_in_group("item_drop"):
		items_in_range.erase(area)
		print(items_in_range)
	if area.is_in_group("basket"):
		near_basket = false
	if area.is_in_group("item_pan"):
		items_in_range.erase(area)
		near_pan = false
	if area.is_in_group("oven"):
		near_oven = false

func _input(event):
	if event.is_action_pressed("interact"):
		if carrying_item: 
			if near_basket:
				erase_item()
			else:
				drop_item()
		elif carrying_pan: 
			if near_oven:
				place_pan()
		else:
			if !items_in_range.is_empty():
				pickup_item(items_in_range.pick_random())
