extends CharacterBody2D

#HI PLEASE FIX BUG WHERE YOU DASH DURING A JUMP AND THE JUMP CONTINUES AFTER THE DASH

#export var
@export var speed = 200 #Movement per frame
@export var gravity = 30 #Gravitational pull down
@export var jump_height = 400 #Jump height
@export var dash = 10 #Dash distance
@export var direction = -1 #Started facing left, 1 = left, -1 = right

#onready var
@onready var dash_timer = $Dash_Timer

#other var
var can_dash = true
var air_dash_ok = 1
var dash_active = false
var can_jump = true
var jump_active = false
var air_jump_ok = 1

#Test beneath
func _ready():
	pass

#Main
func _physics_process(delta):
	
	#Gravity
	if !is_on_floor() && dash_active == false:
		velocity.y += gravity
		if velocity.y > 2000:
			velocity.y = 2000
	
	#Recharge dash on floor
	if is_on_floor():
		air_dash_ok = 1
		air_jump_ok = 1
		
	
	#Regular jump
	if Input.is_action_just_pressed("jump") && is_on_floor() && can_jump == true:
		jump_active = true
		velocity.y = -jump_height
		jump_active = false
	
	#Double jump
	if Input.is_action_just_pressed("jump") && not is_on_floor() && air_jump_ok == 1:
		jump_active = true
		velocity.y = -jump_height + (jump_height * 0.1)
		jump_active = false
		air_jump_ok = 0
	
	#Left/Right movement
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = speed * horizontal_direction
	move_and_slide()
	
	#Left/Right direction change
	if Input.is_action_just_pressed("move_left"):
		$Player_Sprite.scale.x = 1
		direction = -1
	if Input.is_action_just_pressed("move_right"):
		$Player_Sprite.scale.x = -1
		direction = 1
	
	#Dashing
	if Input.is_action_just_pressed("dash") && can_dash && air_dash_ok == 1 && jump_active == false:
		can_dash = false
		can_jump = false
		dash_active = true
		if !is_on_floor():
			air_dash_ok = 0
		var predash_y = position.y
		velocity.x = dash * direction
		for i in range(10):
			position.x += dash * direction
			dash_timer.start(0.005)
			await dash_timer.timeout
			position.y = predash_y
		can_dash = true
		can_jump = true
		dash_active = false
		position.y = predash_y
		velocity.y = 0
