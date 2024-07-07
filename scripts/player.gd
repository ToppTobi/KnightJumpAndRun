extends CharacterBody2D

@export var SPEED = 150.0
@export var JUMP_VELOCITY = -300.0
@export var jump_Buffer_Time := 0.4
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D

var jump_Buffer := false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if jump_Buffer:
			jump()
			jump_Buffer = false

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		
		if is_on_floor():
			jump()
		else:
			jump_Buffer = true
			get_tree().create_timer(jump_Buffer_Time).timeout.connect(on_jump_buffer_timeout)

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")

	# Flip Character
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	# Play Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func jump() -> void:
	velocity.y = JUMP_VELOCITY

func on_jump_buffer_timeout() -> void:
	jump_Buffer = false
