extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var ladder_ray_cast = $LadderRayCast

func _physics_process(delta):
	
	var ladderCollider = ladder_ray_cast.get_collider()
	if ladderCollider:
		_ladder_climb(delta)
	else:
		_movement(delta)
	
	_set_animation()
	
	move_and_slide()

# 基础移动和重力
func _movement(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

# 设置精灵翻转
func _set_animation():
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true

# 爬梯子
func _ladder_climb(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if direction:
		velocity = direction * SPEED/2
	else:
		velocity = Vector2.ZERO
	
	if  velocity:
		animated_sprite.play("run")
	else:
		animated_sprite.stop()
		
