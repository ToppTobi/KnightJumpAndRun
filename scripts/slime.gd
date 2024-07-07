extends Node2D

const speed = 25.0

var direction = 1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape_die = $CollisionShapeDie
@onready var player = $"../player"
@onready var timer = $Head/Timer


func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	elif ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	position.x += direction * speed * delta
	

func _on_head_body_entered(body):
	print("DEAD")
	if body == player:
		body.velocity.y = -300
		animated_sprite.play("die")
		direction = 0
		position.x += direction
		timer.start(0.5)

func _on_timer_timeout():
	queue_free()
