extends CharacterBody2D

@export var speed = 500
@export var gravity = 30
@export var jump_height = 600

func _physics_process(_delta):
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 2000:
			velocity.y = 2000
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = -jump_height
	var horizontal_direction = Input.get_axis("move_left", "move_right")
	velocity.x = speed * horizontal_direction
	move_and_slide()
	
	if Input.is_action_just_pressed("move_left"):
		$Player_Sprite.scale.x = 1
	if Input.is_action_just_pressed("move_right"):
		$Player_Sprite.scale.x = -1
