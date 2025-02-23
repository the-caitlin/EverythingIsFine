extends CharacterBody2D

#references
@onready var item_drop = load("res://scenes/itemDrop.tscn")
@onready var item_spr = $item_spr 
@onready var item_pan = $item_pan
@onready var item_egg = $item_egg

@onready var sprite = $AnimatedSprite2D
@onready var oven = $oven

@onready var item_plate = $item_plate
@onready var item_plate_drop = load("res://scenes/plateDrop.tscn")
@onready var pan_drop = load("res://scenes/pan.tscn")
@onready var dog_bowl = $dog_bowl
@onready var dog_bowl_filled = load("res://scenes/DogBowlFilled.tscn")
@onready var item_dog_food = $item_dog_food
@onready var dog_food_drop = load("res://scenes/DogFoodDrop.tscn")

var speed = 100.0
var sprint_speed = 150.0
var acceleration = 10.0  
var current_speed = speed  
var drop_pos: Vector2
var items_in_range: Array = []
var near_basket: bool = false
var near_pan: bool = false
var near_oven: bool = false
var near_fridge: bool = false
var pan_on_oven: bool = false
var near_dog_bowl: bool = false


var near_dog_food = false
var near_plate = false
var near_sock = false

var carrying_sock: bool = false
var carrying_pan: bool = false
var carrying_dog_food: bool = false
var carrying_plate: bool = false
var carrying_egg: bool = false 

func _ready(): 
	item_spr.hide()
	item_pan.hide()
	item_egg.hide()
	item_plate.hide()
	item_dog_food.hide()
	

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
	if near_pan: 
		item.queue_free()
		carrying_pan = true
		item_pan.show()
	elif near_sock: 
		item.queue_free()
		carrying_sock = true
		item_spr.show()
	elif near_plate:
		item.queue_free()
		carrying_plate = true
		item_plate.show()
	elif near_dog_food:
		item.queue_free()
		carrying_dog_food = true
		item_dog_food.show()
	elif near_dog_bowl: 
		#item.queue_free()
		near_dog_bowl = false
		var filled_bowl = dog_bowl_filled.instantiate() 
		filled_bowl.position = Vector2(390, 409)
		filled_bowl.scale = Vector2(1.61, 1.61)
		get_parent().add_child(filled_bowl)
		
		
		
	
func drop_item():
	item_spr.hide()
	var item = item_drop.instantiate()
	item.position = position + drop_pos
	get_parent().add_child(item)
	carrying_sock = false
	
func erase_item():
	item_spr.hide()
	carrying_sock = false
	
func erase_egg():
	item_egg.hide()
	carrying_egg = false
	
func cook_egg(): 
	item_egg.hide()
	carrying_egg = false
	item_plate.show()
	carrying_plate = true
	
func place_pan(): 
	item_pan.hide()
	carrying_pan = false
	var pan = pan_drop.instantiate()
	pan.position = Vector2(89, 557)
	pan.rotate(-90)
	get_parent().add_child(pan)
	
func place_plate(): 
	item_plate.hide()
	carrying_plate = false
	var plate = item_plate_drop.instantiate()
	plate.position = position + drop_pos
	get_parent().add_child(plate)
	
func fill_bowl():
	dog_bowl.queue_free()
	near_dog_bowl = false
	var filled_bowl = dog_bowl_filled.instantiate() 
	
func drop_food(): 
	item_dog_food.hide()
	carrying_dog_food = false
	var dog_food = dog_food_drop.instantiate()
	dog_food.position = position + drop_pos
	get_parent().add_child(dog_food)
	

func _on_pickup_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("item_drop"):
		near_sock = true
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
	if area.is_in_group("fridge"):
		near_fridge = true
	if area.is_in_group("item_plate_drop"):
		near_plate = true 
		items_in_range.append(area)
	if area.is_in_group("dog_bowl"):
		near_dog_bowl = true 
	if area.is_in_group("dog_food"):
		near_dog_food = true 
		items_in_range.append(area)
		

func _on_pickup_range_area_exited(area: Area2D) -> void:
	if area.is_in_group("item_drop"):
		near_sock = false
		items_in_range.erase(area)
		print(items_in_range)
	if area.is_in_group("basket"):
		near_basket = false
	if area.is_in_group("item_pan"):
		items_in_range.erase(area)
		near_pan = false
	if area.is_in_group("oven"):
		near_oven = false
	if area.is_in_group("fridge"):
		near_fridge = false 
	if area.is_in_group("item_plate_drop"):
		near_plate = false
		items_in_range.erase(area)
	if area.is_in_group("dog_bowl"):
		near_dog_bowl = false 
	if area.is_in_group("dog_food"):
		near_dog_food = false
		items_in_range.erase(area)

func _input(event):
	if event.is_action_pressed("interact"):
		if carrying_sock: 
			if near_basket:
				erase_item()
			else:
				drop_item()
		elif near_fridge: 
			if !carrying_egg:
				item_egg.show()
				carrying_egg = true 
			else: 
				erase_egg()
		elif near_oven:
			if pan_on_oven: 
				if carrying_egg: 
					cook_egg()
			elif carrying_pan:
				place_pan()
				pan_on_oven = true
		elif carrying_plate: 
			place_plate()
		elif carrying_dog_food: 
			if near_dog_bowl:
				pickup_item(items_in_range.pick_random())
			else:
				drop_food()
		else:
			if !items_in_range.is_empty():
				pickup_item(items_in_range.pick_random())
